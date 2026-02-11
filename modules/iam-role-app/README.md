# iam-role-app module

Creates an IAM role for applications with optional inline and managed policies.

## Inputs
- `name`, `project`, `environment`, `request_id`
- `assume_role_policy_json` (string, required)
- `inline_policies` (map(string), default `{}`)
- `managed_policy_arns` (list(string), default `[]`)
- `tags` (map(string), default `{}`) merged with required defaults.

## Outputs
- `role_name`
- `role_arn`
