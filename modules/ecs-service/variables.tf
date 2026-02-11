variable "name" {
  type        = string
  description = "Logical name for the ECS service/cluster"
}

variable "project" {
  type        = string
  description = "Project identifier"
}

variable "environment" {
  type        = string
  description = "Environment identifier"
}

variable "request_id" {
  type        = string
  description = "Optional request identifier"
  default     = ""
}

variable "cluster_arn" {
  type        = string
  description = "ECS cluster ARN"
}

variable "container_image" {
  type        = string
  description = "Container image"
}

variable "cpu" {
  type        = number
  description = "Task CPU (e.g., 256, 512, 1024)"
}

variable "memory" {
  type        = number
  description = "Task memory (e.g., 512, 1024, 2048)"
}

variable "desired_count" {
  type        = number
  description = "Desired task count"
  default     = 1
}

variable "container_port" {
  type        = number
  description = "Container port"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the container"
  default     = {}
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for awsvpc networking"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for the service"
}

variable "aws_region" {
  type        = string
  description = "AWS region for logs"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
