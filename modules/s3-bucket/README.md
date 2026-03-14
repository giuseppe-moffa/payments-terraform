# s3-bucket module

Creates a secure S3 bucket with ownership controls, public access blocked, SSE (SSE-S3 or KMS), TLS-only policy, and optional versioning.

## Inputs
- `name` (string, required): full resource name (e.g. project-environment-userName-shortId from TfPilot); sanitized for S3.
- `project` (string, required)
- `environment` (string, required)
- `request_id` (string, optional): adds uniqueness.
- `versioning_enabled` (bool, default `true`)
- `force_destroy` (bool, default `false`)
- `encryption_mode` (string, default `sse-s3`): `sse-s3` or `sse-kms`.
- `kms_key_arn` (string, optional): required when `encryption_mode = "sse-kms"`.
- `tags` (map(string), default `{}`) merged with required defaults.

## Outputs
- `bucket_name`
- `bucket_arn`
