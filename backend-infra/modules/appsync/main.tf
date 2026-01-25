variable "app_name" {
  type        = string
  description = "Application name used for naming AppSync resources."
}

variable "aws_region" {
  type        = string
  description = "AWS region for AppSync endpoints."
}

output "api_id" {
  description = "Placeholder AppSync API ID."
  value       = "${var.app_name}-appsync-api"
}

output "graphql_url" {
  description = "Placeholder AppSync GraphQL URL."
  value       = "https://${var.app_name}.appsync-api.${var.aws_region}.amazonaws.com/graphql"
}
