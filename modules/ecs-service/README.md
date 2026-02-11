# ecs-service module

Creates an ECS service with Fargate task definition, CloudWatch logs, execution role, and deployment circuit breaker.

## Inputs
- `name`, `project`, `environment`, `request_id`
- `cluster_arn`
- `container_image`
- `cpu`, `memory`
- `desired_count` (default `1`)
- `container_port`
- `environment_variables` (map, default `{}`)
- `subnet_ids`, `security_group_ids`
- `aws_region`
- `tags` (map, default `{}`) merged with required defaults.

## Outputs
- `service_name`
- `task_definition_arn`
