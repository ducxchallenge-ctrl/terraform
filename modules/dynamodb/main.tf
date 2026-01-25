variable "app_name" {
  type        = string
  description = "Application name used for naming DynamoDB resources."
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., dev or prod)."
}

variable "billing_mode" {
  type        = string
  description = "DynamoDB billing mode for non-dev environments."
  default     = null
}

variable "read_capacity" {
  type        = number
  description = "Read capacity units when using PROVISIONED billing mode."
  default     = 5
}

variable "write_capacity" {
  type        = number
  description = "Write capacity units when using PROVISIONED billing mode."
  default     = 5
}

locals {
  effective_billing_mode = var.environment == "dev" ? "PAY_PER_REQUEST" : coalesce(var.billing_mode, "PROVISIONED")
}

resource "aws_dynamodb_table" "this" {
  name         = "${var.app_name}-table"
  billing_mode = local.effective_billing_mode
  hash_key     = "pk"
  range_key    = "sk"

  read_capacity  = local.effective_billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = local.effective_billing_mode == "PROVISIONED" ? var.write_capacity : null

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

output "table_name" {
  description = "DynamoDB table name."
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "DynamoDB table ARN."
  value       = aws_dynamodb_table.this.arn
}
