terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "dynamodb" {
  source         = "../../modules/dynamodb"
  app_name       = var.app_name
  environment    = "prod"
  billing_mode   = var.dynamodb_billing_mode
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
}

module "s3_routes" {
  source     = "../../modules/s3_routes"
  app_name   = var.app_name
  aws_region = var.aws_region
}

module "iam" {
  source             = "../../modules/iam"
  app_name           = var.app_name
  dynamodb_table_arn = module.dynamodb.table_arn
  s3_bucket_arn      = module.s3_routes.bucket_arn
}

module "lambda" {
  source                  = "../../modules/lambda"
  app_name                = var.app_name
  artifact_bucket         = var.artifact_bucket
  lambda_s3_key           = var.lambda_s3_key
  lambda_source_code_hash = var.lambda_source_code_hash
  role_arn                = module.iam.role_arn
  table_name              = module.dynamodb.table_name
  route_bucket            = module.s3_routes.bucket_name
  environment             = "prod"
}

module "cognito" {
  source   = "../../modules/cognito"
  app_name = var.app_name
  domain   = var.cognito_domain
}

module "appsync" {
  source              = "../../modules/appsync"
  app_name            = var.app_name
  aws_region          = var.aws_region
  user_pool_id        = module.cognito.user_pool_id
  lambda_function_arn = module.lambda.function_arn
  schema_path         = var.appsync_schema_path
}
