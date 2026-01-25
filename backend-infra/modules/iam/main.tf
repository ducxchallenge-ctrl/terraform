variable "app_name" {
  type        = string
  description = "Application name used for naming IAM resources."
}

output "role_name" {
  description = "Placeholder IAM role name."
  value       = "${var.app_name}-role"
}

output "role_arn" {
  description = "Placeholder IAM role ARN."
  value       = "arn:aws:iam::account-id:role/${var.app_name}-role"
}
