variable "app_name" {
  type        = string
  description = "Application name used for naming S3 routing bucket."
}

variable "aws_region" {
  type        = string
  description = "AWS region for S3 routing endpoints."
}

resource "aws_s3_bucket" "routes" {
  bucket = "${var.app_name}-routes"
}

resource "aws_s3_bucket_public_access_block" "routes" {
  bucket                  = aws_s3_bucket.routes.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "routes" {
  bucket = aws_s3_bucket.routes.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "routes" {
  bucket = aws_s3_bucket.routes.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

output "bucket_name" {
  description = "S3 routes bucket name."
  value       = aws_s3_bucket.routes.bucket
}

output "bucket_arn" {
  description = "S3 routes bucket ARN."
  value       = aws_s3_bucket.routes.arn
}

output "bucket_url" {
  description = "S3 routes bucket URL."
  value       = "https://${aws_s3_bucket.routes.bucket}.s3.${var.aws_region}.amazonaws.com"
}
