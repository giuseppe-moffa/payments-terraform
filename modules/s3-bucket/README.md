# s3-bucket module

Creates a secure S3 bucket with ownership controls, public access blocked, SSE (SSE-S3 or KMS), TLS-only policy, and optional versioning.

## Inputs
- `name` (string, required): logical name.
- `project` (string, required)
- `environment` (string, required)
- `request_id` (string, optional): adds uniqueness.
- `bucket_name` (string, optional): override derived name.
- `versioning_enabled` (bool, default `true`)
- `force_destroy` (bool, default `false`)
- `kms_key_arn` (string, optional): KMS key ARN; null uses SSE-S3.
- `tags` (map(string), default `{}`) merged with required defaults.

## Outputs
- `bucket_name`
- `bucket_arn`
