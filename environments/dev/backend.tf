terraform {
  backend "s3" {
    bucket         = "shareframe-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
