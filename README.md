# payments-terraform

Infra-only Terraform repo for the “payments” project. Application code lives elsewhere; this repo manages cloud resources only.

## Layout
- `modules/` — shared modules (empty scaffold; add as needed).
- `envs/dev` — Terraform root for dev.
- `envs/prod` — Terraform root for prod.
- `.github/workflows/plan.yml` — fmt + init + plan for dev/prod (PR + manual).
- `.github/workflows/apply.yml` — manual apply per environment.

## Env roots
Each environment is a separate Terraform root (`envs/dev`, `envs/prod`). Files:
- `main.tf` — minimal root with required_version/providers and a placeholder output.
- `providers.tf` — AWS provider, region via `var.aws_region` (default eu-west-2), default tags: `project=payments`, `environment`, `managed_by=tfpilot`.
- `backend.tf` — S3 backend + DynamoDB lock (dev/prod buckets/tables).
- `terraform.tfvars` — default region.
- `tfpilot.<type>.tf` — TfPilot-managed files per resource type (ecs/s3/sqs/misc); do not edit by hand.

## Workflows
- `plan.yml`: triggers on PR and workflow_dispatch; runs fmt, init, and plan for both envs.
- `apply.yml`: workflow_dispatch only; input `environment` (dev|prod); runs init+apply in that env. No auto-apply on push/PR.

## Usage
1) Bootstrap (once per account/env): create S3 buckets `tfstate-payments-dev` / `tfstate-payments-prod` (versioning+encryption+block public) and DynamoDB tables `tfstate-lock-payments-dev` / `tfstate-lock-payments-prod` with partition key `LockID` (string).
2) `cd envs/dev && terraform init && terraform plan` (repeat for prod).
3) Use GitHub Actions workflows for plan/apply with OIDC-backed AWS role.

## TfPilot
TfPilot will write generated resources only to `envs/*/tfpilot.generated.tf`. Keep other files under source control and review changes in PRs.
# payments-terraform