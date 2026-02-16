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

variable "block_public_access" {
  type        = bool
  description = "Block all public access"
  default     = true
}

variable "enable_lifecycle" {
  type        = bool
  description = "Enable lifecycle config for noncurrent versions and multipart cleanup"
  default     = false
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

  validation {
    condition = lower(var.encryption_mode) != "sse-kms" ? true : (var.kms_key_arn != null && var.kms_key_arn != "")
    error_message = "kms_key_arn is required when encryption_mode is sse-kms."
  }
}

variable "encryption_mode" {
  type        = string
  description = "Encryption mode: sse-s3 (AES256), sse-kms-aws-managed (aws/s3), or sse-kms-cmk (customer-managed key)"
  default     = "sse-s3"

  validation {
    condition     = contains(["sse-s3", "sse-kms-aws-managed", "sse-kms-cmk"], lower(var.encryption_mode))
    error_message = "encryption_mode must be one of: sse-s3, sse-kms-aws-managed, sse-kms-cmk."
  }
}

variable "noncurrent_expiration_days" {
  type        = number
  description = "Days before expiring noncurrent versions"
  default     = 30

  validation {
    condition     = var.noncurrent_expiration_days >= 1 && var.noncurrent_expiration_days <= 3650
    error_message = "noncurrent_expiration_days must be between 1 and 3650."
  }
}

variable "abort_multipart_days" {
  type        = number
  description = "Days before aborting incomplete multipart uploads"
  default     = 7

  validation {
    condition     = var.abort_multipart_days >= 1 && var.abort_multipart_days <= 365
    error_message = "abort_multipart_days must be between 1 and 365."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
