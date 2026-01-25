output "appsync_api_id" {
  description = "AppSync API identifier."
  value       = module.appsync.api_id
}

output "appsync_graphql_url" {
  description = "AppSync GraphQL endpoint URL."
  value       = module.appsync.graphql_url
}

output "cognito_user_pool_id" {
  description = "Cognito user pool ID."
  value       = module.cognito.user_pool_id
}

output "cognito_user_pool_client_id" {
  description = "Cognito user pool client ID."
  value       = module.cognito.user_pool_client_id
}

output "dynamodb_table_name" {
  description = "DynamoDB table name."
  value       = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN."
  value       = module.dynamodb.table_arn
}

output "lambda_function_name" {
  description = "Lambda function name."
  value       = module.lambda.function_name
}

output "lambda_function_arn" {
  description = "Lambda function ARN."
  value       = module.lambda.function_arn
}

output "s3_routes_bucket_name" {
  description = "S3 routes bucket name."
  value       = module.s3_routes.bucket_name
}

output "s3_routes_bucket_url" {
  description = "S3 routes bucket URL."
  value       = module.s3_routes.bucket_url
}

output "iam_role_name" {
  description = "IAM role name."
  value       = module.iam.role_name
}

output "iam_role_arn" {
  description = "IAM role ARN."
  value       = module.iam.role_arn
}
