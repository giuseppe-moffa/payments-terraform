# Managed by TfPilot - do not edit by hand

/* --- tfpilot example sqs start --- */
module "tfpilot_request_example_sqs" {
  source = "../../modules/sqs-queue"

  name        = "example"
  project     = "payments"
  environment = "dev"
  request_id  = "req-example"

  dlq_enabled               = true
  max_receive_count         = 5
  message_retention_seconds = 345600

  tags = {
    project     = "payments"
    environment = "dev"
    managed_by  = "tfpilot"
  }
}
/* --- tfpilot example sqs end --- */
