terraform {
  backend "s3" {
    bucket         = "tfpilot-tfstate-payments-prod"
    key            = "envs/prod/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tfpilot-tfstate-lock-payments-prod"
    encrypt        = true
  }
}
