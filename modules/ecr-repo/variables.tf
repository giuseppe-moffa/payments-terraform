variable "name" {
  type        = string
  description = "Full repository name (e.g. project-environment-userName-shortId from TfPilot); sanitized for ECR"
}

variable "project" {
  type        = string
  description = "Project identifier"
}

variable "environment" {
  type        = string
  description = "Environment identifier (e.g. dev, prod)"
}

variable "request_id" {
  type        = string
  description = "Request correlation id"
  default     = ""
}

variable "scan_on_push" {
  type        = bool
  description = "Enable image scanning on push"
  default     = true
}

variable "retain_images" {
  type        = number
  description = "Lifecycle policy: retain last N images (expire older)"
  default     = 5

  validation {
    condition     = var.retain_images >= 1 && var.retain_images <= 100
    error_message = "retain_images must be between 1 and 100."
  }
}

variable "force_delete" {
  type        = bool
  description = "Allow force delete of repository even when it contains images"
  default     = false
}

variable "image_tag_mutability" {
  type        = string
  description = "Image tag mutability: MUTABLE or IMMUTABLE"
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
