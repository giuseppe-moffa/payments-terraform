locals {
  base_name = lower(join("-", compact([
    var.project,
    var.environment,
    var.name,
    var.request_id != "" ? var.request_id : null,
  ])))

  service_name = substr(replace(local.base_name, "/[^a-z0-9-]/", ""), 0, 255)
  log_group    = "/ecs/${local.service_name}"

  required_tags = {
    ManagedBy        = "tfpilot"
    TfPilotRequestId = var.request_id
    Project          = var.project
    Environment      = var.environment
  }

  merged_tags = merge(local.required_tags, var.tags)
}

resource "aws_cloudwatch_log_group" "service" {
  name              = local.log_group
  retention_in_days = 30
  tags              = local.merged_tags
}

module "execution_role" {
  source = "../iam-role-app"

  name        = "${local.service_name}-exec"
  project     = var.project
  environment = var.environment
  request_id  = var.request_id

  assume_role_policy_json = data.aws_iam_policy_document.ecs_tasks.json
  managed_policy_arns     = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
  tags                    = var.tags
}

data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = module.execution_role.role_arn

  container_definitions = jsonencode([
    {
      name      = local.service_name
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        for k, v in var.environment_variables : {
          name  = k
          value = v
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.service.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = local.merged_tags
}

resource "aws_ecs_service" "this" {
  name            = local.service_name
  cluster         = var.cluster_arn
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    assign_public_ip = true
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
  }

  tags = local.merged_tags
}
