variable "name" {
  type        = string
  description = "Logical name for the queue"
}

variable "project" {
  type        = string
  description = "Project identifier"
}

variable "environment" {
  type        = string
  description = "Environment identifier (e.g., dev, prod)"
}

variable "request_id" {
  type        = string
  description = "Optional request identifier to add uniqueness"
  default     = ""
}

variable "dlq_enabled" {
  type        = bool
  description = "Whether to create a dead-letter queue"
  default     = true
}

variable "max_receive_count" {
  type        = number
  description = "Max receives before moving to DLQ"
  default     = 5
}

variable "message_retention_seconds" {
  type        = number
  description = "Message retention in seconds"
  default     = 345600 # 4 days
}

variable "dlq_message_retention_seconds" {
  type        = number
  description = "DLQ message retention in seconds"
  default     = 1209600 # 14 days
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout in seconds"
  default     = 30
}

variable "receive_wait_time_seconds" {
  type        = number
  description = "Long polling wait time in seconds"
  default     = 20
}

variable "kms_key_id" {
  type        = string
  description = "KMS key for SSE; empty uses SQS-managed SSE"
  default     = ""
}

variable "fifo" {
  type        = bool
  description = "Create FIFO queue"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge with required defaults"
  default     = {}
}
