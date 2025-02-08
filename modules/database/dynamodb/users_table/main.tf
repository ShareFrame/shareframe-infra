terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_dynamodb_table" "users" {
  name         = var.table_name
  billing_mode = var.billing_mode
  hash_key     = "UserId"
  table_class  = var.table_class

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }

  global_secondary_index {
    name            = "Email-index"
    hash_key        = "Email"
    projection_type = "ALL"
  }

  deletion_protection_enabled = var.deletion_protection_enabled

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }

  tags = {
    Name = var.table_name
  }
}
