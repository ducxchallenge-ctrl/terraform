variable "app_name" {
  type        = string
  description = "Application name used to namespace resources."
}

variable "aws_region" {
  type        = string
  description = "AWS region for all resources."
}

variable "artifact_bucket" {
  type        = string
  description = "S3 bucket that stores Lambda artifacts."
}

variable "lambda_s3_key" {
  type        = string
  description = "S3 key for the Lambda artifact."
}

variable "lambda_source_code_hash" {
  type        = string
  description = "Base64-encoded SHA256 hash of the Lambda source bundle."
}

variable "tf_state_bucket" {
  type        = string
  description = "S3 bucket for Terraform state storage."
}

variable "tf_lock_table" {
  type        = string
  description = "DynamoDB table for Terraform state locking."
}
