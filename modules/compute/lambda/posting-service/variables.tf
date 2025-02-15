variable "function_name" {
  type    = string
  default = "posting-service"
}

variable "role_arn" {
  type    = string
  default = "arn:aws:iam::585768148590:role/service-role/posting-service-role"
}

variable "handler" {
  type    = string
  default = "hello.handler"
}

variable "runtime" {
  type    = string
  default = "provided.al2023"
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 3
}

variable "architectures" {
  type    = list(string)
  default = ["x86_64"]
}

variable "s3_bucket" {
  type    = string
  default = "shareframe-lambda-bucket"
}

variable "s3_key" {
  type    = string
  default = "posting-service/main.zip"
}

variable "environment_variables" {
  type = map(string)
  default = {
    ENV  = "production"
    S3_BUCKET = "shareframe-lexicons-bucket"
  }
}
