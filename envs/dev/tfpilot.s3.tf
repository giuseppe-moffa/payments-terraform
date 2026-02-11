# Managed by TfPilot - do not edit by hand

/* --- tfpilot example s3 start --- */
module "tfpilot_request_example_s3" {
  source = "../../modules/s3-bucket"

  name        = "example"
  project     = "payments"
  environment = "dev"
  request_id  = "req-example"

  versioning_enabled = false
  tags = {
    project     = "payments"
    environment = "dev"
    managed_by  = "tfpilot"
  }
}
/* --- tfpilot example s3 end --- */
