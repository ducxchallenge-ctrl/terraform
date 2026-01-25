variable "app_name" {
  type        = string
  description = "Application name used for naming Cognito resources."
}

output "user_pool_id" {
  description = "Placeholder Cognito user pool ID."
  value       = "${var.app_name}-user-pool"
}

output "user_pool_client_id" {
  description = "Placeholder Cognito user pool client ID."
  value       = "${var.app_name}-user-pool-client"
}
