locals {
  base_name = lower(join("-", compact([
    var.project,
    var.environment,
    var.name,
    var.request_id != "" ? var.request_id : null,
  ])))

  role_name = substr(replace(local.base_name, "/[^a-z0-9+=,.@_-]/", ""), 0, 64)

  required_tags = {
    ManagedBy        = "tfpilot"
    TfPilotRequestId = var.request_id
    Project          = var.project
    Environment      = var.environment
  }

  merged_tags = merge(local.required_tags, var.tags)
}

resource "aws_iam_role" "this" {
  name               = local.role_name
  assume_role_policy = var.assume_role_policy_json
  tags               = local.merged_tags
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies

  name   = each.key
  role   = aws_iam_role.this.id
  policy = each.value
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
