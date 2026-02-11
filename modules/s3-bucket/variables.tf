variable "name" {
  type        = string
  description = "Logical name for the bucket (used if bucket_name not provided)"
}

variable "project" {
  type        = string
  description = "Project identifier"
}

variable "environment" {
  type        = string
  description = "Environment identifier (e.g., dev, prod)"
}

variable "request_id" {
  type        = string
  description = "Optional request identifier to add uniqueness"
  default     = ""
}

variable "bucket_name" {
  type        = string
  description = "Override for bucket name; set null to derive"
  default     = null
}

variable "versioning_enabled" {
  type        = bool
  description = "Enable S3 versioning"
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Allow force destroy of bucket"
  default     = false
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for bucket encryption; null for SSE-S3"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
