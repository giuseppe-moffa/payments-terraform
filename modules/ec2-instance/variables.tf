variable "name" {
  type        = string
  description = "Full instance name (e.g. project-environment-userName-shortId from TfPilot); used for Name tag and sanitized"
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

variable "instance_type" {
  type        = string
  description = "EC2 instance type (e.g., t3.micro, t3.small)"
}

variable "network_preset" {
  type        = string
  description = "Network preset id (e.g. shared-public); provides VPC, default subnet and security group"
}

variable "subnet_id" {
  type        = string
  description = "Override: subnet ID (leave null to use preset default)"
  default     = null
}

variable "subnet_type" {
  type        = string
  description = "Subnet type: public or private (optional; for reference or lookup)"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "Override: security group IDs (leave empty to use preset default)"
  default     = []
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the instance. Omit if using ami_ssm_param."
  default     = ""
}

variable "ami_ssm_param" {
  type        = string
  description = "SSM parameter name for AMI ID (e.g., /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64). Used when ami_id is empty."
  default     = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"

  validation {
    condition     = var.ami_id != "" || var.ami_ssm_param != ""
    error_message = "Either ami_id or ami_ssm_param must be set."
  }
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name for SSH access"
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address"
  default     = false
}

variable "root_volume_size_gb" {
  type        = number
  description = "Root volume size in GB"
  default     = 20
}

variable "monitoring" {
  type        = bool
  description = "Enable detailed (basic) CloudWatch monitoring"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
