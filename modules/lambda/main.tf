variable "app_name" {
  type        = string
  description = "Application name used for naming Lambda resources."
}

variable "artifact_bucket" {
  type        = string
  description = "S3 bucket containing Lambda artifacts."
}

variable "lambda_s3_key" {
  type        = string
  description = "S3 key for Lambda artifact."
}

variable "lambda_source_code_hash" {
  type        = string
  description = "Source code hash for Lambda deployment."
}

variable "role_arn" {
  type        = string
  description = "IAM role ARN for the Lambda execution role."
}

variable "table_name" {
  type        = string
  description = "DynamoDB table name for Lambda environment variables."
}

variable "route_bucket" {
  type        = string
  description = "S3 bucket name for route storage."
}

variable "aws_region" {
  type        = string
  description = "AWS region for Lambda environment variables."
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., dev or prod)."
}

locals {
  log_retention_days = var.environment == "prod" ? 30 : 14
}

resource "aws_lambda_function" "this" {
  function_name    = "${var.app_name}-lambda"
  role             = var.role_arn
  runtime          = "nodejs24.x"
  handler          = "index.handler"
  architectures    = ["arm64"]
  s3_bucket        = var.artifact_bucket
  s3_key           = var.lambda_s3_key
  source_code_hash = var.lambda_source_code_hash

  environment {
    variables = {
      TABLE_NAME   = var.table_name
      ROUTE_BUCKET = var.route_bucket
      AWS_REGION   = var.aws_region
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = local.log_retention_days
}

output "function_name" {
  description = "Lambda function name."
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "Lambda function ARN."
  value       = aws_lambda_function.this.arn
}
