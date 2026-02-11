output "queue_url" {
  description = "URL of the SQS queue"
  value       = aws_sqs_queue.this.url
}

output "queue_arn" {
  description = "ARN of the SQS queue"
  value       = aws_sqs_queue.this.arn
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue (if created)"
  value       = var.dlq_enabled ? aws_sqs_queue.dlq[0].arn : null
}
