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

output "function_name" {
  description = "Placeholder Lambda function name."
  value       = "${var.app_name}-lambda"
}

output "function_arn" {
  description = "Placeholder Lambda function ARN."
  value       = "arn:aws:lambda:region:account-id:function:${var.app_name}-lambda"
}
