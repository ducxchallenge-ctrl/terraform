variable "app_name" {
  type        = string
  description = "Application name used for naming DynamoDB resources."
}

output "table_name" {
  description = "Placeholder DynamoDB table name."
  value       = "${var.app_name}-table"
}

output "table_arn" {
  description = "Placeholder DynamoDB table ARN."
  value       = "arn:aws:dynamodb:region:account-id:table/${var.app_name}-table"
}
