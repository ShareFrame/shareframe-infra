resource "aws_lambda_function" "profile_service" {
  function_name    = var.function_name
  role            = var.role_arn
  handler         = var.handler
  runtime         = var.runtime
  memory_size     = var.memory_size
  timeout         = var.timeout
  architectures   = var.architectures

  s3_bucket       = var.s3_bucket
  s3_key          = var.s3_key

  environment {
    variables = var.environment_variables
  }

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_logs.name
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "profile-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
