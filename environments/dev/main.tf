module "user_management_service" {
  source        = "../../modules/compute/lambda/user-management-service"
  function_name = "user-management-service"
  role_arn      = "arn:aws:iam::585768148590:role/service-role/user-management-service-role-ncxlbkpr"
  handler       = "main"
  runtime       = "provided.al2023"
  memory_size   = 128
  timeout       = 3
  architectures = ["x86_64"]

  s3_bucket = "shareframe-lambda-deployments"
  s3_key    = "user-management-service/user-management-service-lambda.zip"

  environment_variables = {
    ATPROTO_BASE_URL       = "https://shareframe.social"
    PDS_ADMIN_SECRET_NAME  = "pds_admin"
    DYNAMO_TABLE_NAME      = "Users"
    EMAIL_SERVICE_KEY      = "resend_apikey"
    PDS_UTIL_ACCOUNT_CREDS = "admin_account_info"
  }
}

module "profile_service" {
  source        = "../../modules/compute/lambda/profile-service"
  function_name = "profile-service"
  role_arn      = "arn:aws:iam::585768148590:role/service-role/profile-service-role-cpkgb5ro"
  handler       = "main"
  runtime       = "provided.al2023"
  memory_size   = 128
  timeout       = 3
  architectures = ["x86_64"]

  s3_bucket = "shareframe-lambda-deployments"
  s3_key    = "profile-service/profile-service-lambda.zip"

  environment_variables = {
    ATPROTO_BASE_URL       = "https://shareframe.social"
    PDS_UTIL_ACCOUNT_CREDS = "admin_account_info"
  }
}

module "appsync" {
  source = "../../modules/appsync"
}

module "shareframe_pds" {
  source             = "../../modules/compute/ec2"
  ami                = "ami-0ee2ab46e8c10e0d2"
  instance_type      = "t2.micro"
  subnet_id          = "subnet-00e6fc2a1da6f5dd3"
  security_group     = "sg-01e5d5488d13a290e"
  ebs_volume_id      = "vol-08db473cf4c882bc5"
  eip_allocation_id  = "eipalloc-0ae265d90bbaa7985"
}

module "users_table" {
  source      = "../../modules/database/dynamodb/users_table"
  table_name  = "Users"
  billing_mode = "PAY_PER_REQUEST"
}


provider "aws" {
  region = "us-east-2"
}