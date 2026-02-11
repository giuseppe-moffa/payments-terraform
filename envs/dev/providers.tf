provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      project     = "payments"
      environment = "dev"
      managed_by  = "tfpilot"
    }
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for this environment"
  default     = "eu-west-2"
}
