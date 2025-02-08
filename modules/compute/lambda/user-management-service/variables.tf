variable "function_name" {}
variable "role_arn" {}
variable "handler" {}
variable "runtime" {}
variable "memory_size" { default = 128 }
variable "timeout" { default = 3 }
variable "architectures" { default = ["x86_64"] }
variable "s3_bucket" {}
variable "s3_key" {}
variable "environment_variables" { type = map(string) }