terraform {
  backend "s3" {
    bucket         = "terraform-state-info-btc"
    region         = "us-east-2"
    key            = "state/terraform.tfstate"
    dynamodb_table = "dynamodb-state-info"
  }
}
