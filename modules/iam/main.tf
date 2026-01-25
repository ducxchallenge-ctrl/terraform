variable "app_name" {
  type        = string
  description = "Application name used for naming IAM resources."
}

variable "dynamodb_table_arn" {
  type        = string
  description = "ARN of the DynamoDB table accessed by Lambda."
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket accessed by Lambda."
}

resource "aws_iam_role" "lambda" {
  name = "${var.app_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_access" {
  name = "${var.app_name}-lambda-access"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          var.dynamodb_table_arn,
          "${var.dynamodb_table_arn}/index/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${var.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = var.s3_bucket_arn
      }
    ]
  })
}

output "role_name" {
  description = "IAM role name."
  value       = aws_iam_role.lambda.name
}

output "role_arn" {
  description = "IAM role ARN."
  value       = aws_iam_role.lambda.arn
}
