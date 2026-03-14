# Backend config injected by workflows via -backend-config (bucket, key, region, dynamodb_table, encrypt)
terraform {
  backend "s3" {}
}
