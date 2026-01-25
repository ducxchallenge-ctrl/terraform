variable "app_name" {
  type        = string
  description = "Application name used for naming S3 routing bucket."
}

variable "aws_region" {
  type        = string
  description = "AWS region for S3 routing endpoints."
}

output "bucket_name" {
  description = "Placeholder S3 routes bucket name."
  value       = "${var.app_name}-routes"
}

output "bucket_url" {
  description = "Placeholder S3 routes bucket URL."
  value       = "https://${var.app_name}-routes.s3.${var.aws_region}.amazonaws.com"
}
