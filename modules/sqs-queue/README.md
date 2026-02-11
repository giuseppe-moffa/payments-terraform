# sqs-queue module

Creates an SQS queue with SSE, optional DLQ, and configurable retention.

## Inputs
- `name` (string, required)
- `project` (string, required)
- `environment` (string, required)
- `request_id` (string, optional)
- `fifo` (bool, default `false`)
- `dlq_enabled` (bool, default `true`)
- `max_receive_count` (number, default `5`)
- `message_retention_seconds` (number, default `345600`)
- `dlq_message_retention_seconds` (number, default `1209600`)
- `visibility_timeout_seconds` (number, default `30`)
- `kms_key_id` (string, optional): empty enables SQS-managed SSE
- `tags` (map(string), required)

## Outputs
- `queue_url`
- `queue_arn`
- `dlq_arn` (when created)
