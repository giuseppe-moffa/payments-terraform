# ecr-repo module

Creates an ECR repository with image scanning on push, AES256 encryption, lifecycle policy to retain last N images, and configurable tag mutability.

## Inputs

- `name` (string, required): full repository name (e.g. project-environment-userName-shortId from TfPilot); sanitized for ECR.
- `project` (string, required)
- `environment` (string, required)
- `request_id` (string, optional): request correlation id.
- `scan_on_push` (bool, default `true`): enable image scanning on push.
- `retain_images` (number, default `5`): lifecycle policy keeps last N images (1–100).
- `force_delete` (bool, default `false`): allow force delete when repo has images.
- `image_tag_mutability` (string, default `"IMMUTABLE"`): `MUTABLE` or `IMMUTABLE`.
- `tags` (map(string), default `{}`): extra tags merged with required platform tags.

## Outputs

- `repository_url`
- `repository_arn`
- `repository_name`
