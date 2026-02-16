locals {
  base_bucket_name = lower(join("-", compact([
    var.project,
    var.environment,
    var.name,
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
      sse_algorithm = lower(var.encryption_mode) == "sse-s3" ? "AES256" : "aws:kms"
      kms_master_key_id = lower(var.encryption_mode) == "sse-kms-cmk" ? var.kms_key_arn : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access
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
    status = var.enable_lifecycle ? "Enabled" : "Disabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_expiration_days
    }

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_multipart_days
    }
  }
}
