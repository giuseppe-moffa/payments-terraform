# name from TfPilot is the full resource name (project-env-userName-shortId); use as-is, only sanitize for ECR
locals {
  # ECR repo name: [a-z0-9][a-z0-9._-]*
  name = substr(replace(lower(var.name), "/[^a-z0-9._-]/", "-"), 0, 256)

  required_tags = {
    ManagedBy        = "tfpilot"
    TfPilotRequestId  = var.request_id
    Project          = var.project
    Environment      = var.environment
  }

  merged_tags = merge(var.tags, local.required_tags)

  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last ${var.retain_images} images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = var.retain_images
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_repository" "this" {
  name                 = local.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = local.merged_tags
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = local.lifecycle_policy
}
