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

variable "dynamodb_billing_mode" {
  type        = string
  description = "DynamoDB billing mode for production (PAY_PER_REQUEST or PROVISIONED)."
  default     = "PROVISIONED"
}

variable "dynamodb_read_capacity" {
  type        = number
  description = "Read capacity units when using PROVISIONED billing mode."
  default     = 5
}

variable "dynamodb_write_capacity" {
  type        = number
  description = "Write capacity units when using PROVISIONED billing mode."
  default     = 5
}

variable "appsync_schema_path" {
  type        = string
  description = "Path to the AppSync GraphQL schema file."
  default     = "../../modules/appsync/schema.graphql"
}

variable "cognito_domain" {
  type        = string
  description = "Optional Cognito hosted UI domain prefix."
  default     = null
}

variable "tf_state_bucket" {
  type        = string
  description = "S3 bucket for Terraform state storage."
}

variable "tf_lock_table" {
  type        = string
  description = "DynamoDB table for Terraform state locking."
}
