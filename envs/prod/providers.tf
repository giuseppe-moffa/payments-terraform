provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "tfpilot"
      Project     = "payments"
      Environment = "prod"
    }
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for this environment"
  default     = "eu-west-2"
}
