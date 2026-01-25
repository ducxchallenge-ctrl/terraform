variable "app_name" {
  type        = string
  description = "Application name used for naming Cognito resources."
}

variable "domain" {
  type        = string
  description = "Optional Cognito hosted UI domain prefix."
  default     = null
}

resource "aws_cognito_user_pool" "this" {
  name = "${var.app_name}-user-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }
}

resource "aws_cognito_user_pool_client" "web" {
  name         = "${var.app_name}-web"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_client" "ios" {
  name         = "${var.app_name}-ios"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_client" "android" {
  name         = "${var.app_name}-android"
  user_pool_id = aws_cognito_user_pool.this.id

  generate_secret = false

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_domain" "this" {
  count       = var.domain == null ? 0 : 1
  domain      = var.domain
  user_pool_id = aws_cognito_user_pool.this.id
}

output "user_pool_id" {
  description = "Cognito user pool ID."
  value       = aws_cognito_user_pool.this.id
}

output "web_client_id" {
  description = "Cognito web client ID."
  value       = aws_cognito_user_pool_client.web.id
}

output "ios_client_id" {
  description = "Cognito iOS client ID."
  value       = aws_cognito_user_pool_client.ios.id
}

output "android_client_id" {
  description = "Cognito Android client ID."
  value       = aws_cognito_user_pool_client.android.id
}

output "domain" {
  description = "Cognito hosted UI domain."
  value       = var.domain
}
