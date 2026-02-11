terraform {
  backend "s3" {
    bucket         = "tfpilot-tfstate-payments-dev"
    key            = "envs/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tfpilot-tfstate-lock-payments-dev"
    encrypt        = true
  }
}
