variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "The billing mode for the DynamoDB table (PAY_PER_REQUEST or PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "table_class" {
  description = "The table class (STANDARD or STANDARD_INFREQUENT_ACCESS)"
  type        = string
  default     = "STANDARD"
}

variable "deletion_protection_enabled" {
  description = "Enable deletion protection for the DynamoDB table"
  type        = bool
  default     = false
}
