locals {
  base_queue_name = lower(join("-", compact([
    var.project,
    var.environment,
    var.name,
    var.request_id != "" ? var.request_id : null,
  ])))

  queue_name = substr(replace(local.base_queue_name, "/[^a-z0-9-]/", ""), 0, 80)

  required_tags = {
    ManagedBy        = "tfpilot"
    TfPilotRequestId = var.request_id
    Project          = var.project
    Environment      = var.environment
  }

  merged_tags = merge(local.required_tags, var.tags)
}

resource "aws_sqs_queue" "dlq" {
  count = var.dlq_enabled ? 1 : 0

  name                        = var.fifo ? "${local.queue_name}-dlq.fifo" : "${local.queue_name}-dlq"
  fifo_queue                  = var.fifo
  sqs_managed_sse_enabled     = var.kms_key_id == "" ? true : false
  kms_master_key_id           = var.kms_key_id != "" ? var.kms_key_id : null
  message_retention_seconds   = var.dlq_message_retention_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  content_based_deduplication = var.fifo
  tags                        = local.merged_tags
}

resource "aws_sqs_queue" "this" {
  name = var.fifo ? "${local.queue_name}.fifo" : local.queue_name

  fifo_queue                  = var.fifo
  sqs_managed_sse_enabled     = var.kms_key_id == "" ? true : false
  kms_master_key_id           = var.kms_key_id != "" ? var.kms_key_id : null
  message_retention_seconds   = var.message_retention_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  receive_wait_time_seconds   = var.receive_wait_time_seconds
  content_based_deduplication = var.fifo

  redrive_policy = var.dlq_enabled ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = local.merged_tags
}
