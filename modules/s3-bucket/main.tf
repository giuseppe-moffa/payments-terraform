locals {
  base_bucket_name = lower(join("-", compact([
    var.project,
    var.environment,
    var.name,
    var.request_id != "" ? var.request_id : null,
  ])))

  bucket_name = coalesce(var.bucket_name, substr(replace(local.base_bucket_name, "/[^a-z0-9-]/", ""), 0, 63))

  required_tags = {
    ManagedBy        = "tfpilot"
    TfPilotRequestId = var.request_id
    Project          = var.project
    Environment      = var.environment
  }

  sanitized_tags = {
    for k, v in var.tags :
    k => v
    if !contains(["managedby", "tfpilotrequestid", "project", "environment"], lower(k))
  }

  merged_tags = merge(local.sanitized_tags, local.required_tags)
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  tags = local.merged_tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_key_arn != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid     = "DenyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "deny_insecure" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.deny_insecure_transport.json
}

resource "aws_s3_bucket_lifecycle_configuration" "default" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "default-lifecycle"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_multipart_days
    }
  }
}

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

variable "noncurrent_expiration_days" {
  type        = number
  description = "Days before expiring noncurrent versions"
  default     = 30
}

variable "abort_multipart_days" {
  type        = number
  description = "Days before aborting incomplete multipart uploads"
  default     = 7
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
