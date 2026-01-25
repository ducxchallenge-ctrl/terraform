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

module "appsync" {
  source     = "../../modules/appsync"
  app_name   = var.app_name
  aws_region = var.aws_region
}

module "cognito" {
  source   = "../../modules/cognito"
  app_name = var.app_name
}

module "dynamodb" {
  source   = "../../modules/dynamodb"
  app_name = var.app_name
}

module "lambda" {
  source                 = "../../modules/lambda"
  app_name               = var.app_name
  artifact_bucket        = var.artifact_bucket
  lambda_s3_key           = var.lambda_s3_key
  lambda_source_code_hash = var.lambda_source_code_hash
}

module "s3_routes" {
  source     = "../../modules/s3_routes"
  app_name   = var.app_name
  aws_region = var.aws_region
}

module "iam" {
  source   = "../../modules/iam"
  app_name = var.app_name
}
