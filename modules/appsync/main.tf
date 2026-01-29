variable "app_name" {
  type        = string
  description = "Application name used for naming AppSync resources."
}

variable "aws_region" {
  type        = string
  description = "AWS region for AppSync endpoints."
}

variable "schema_path" {
  type        = string
  description = "Path to the GraphQL schema file."
  default     = null
}

variable "user_pool_id" {
  type        = string
  description = "Cognito User Pool ID for AppSßync authentication."
}

variable "lambda_function_arn" {
  type        = string
  description = "ARN of the Lambda function backing AppSync resolvers."
}

locals {
  schema_path     = coalesce(var.schema_path, "${path.module}/schema.graphql")
  schema_contents = file(local.schema_path)

  query_block_matches    = regexall("type Query\\s*\\{([\\s\\S]*?)\\}", local.schema_contents)
  mutation_block_matches = regexall("type Mutation\\s*\\{([\\s\\S]*?)\\}", local.schema_contents)

  query_block    = length(local.query_block_matches) > 0 ? local.query_block_matches[0][0] : ""
  mutation_block = length(local.mutation_block_matches) > 0 ? local.mutation_block_matches[0][0] : ""

  query_fields = distinct(compact([
    for line in split("\n", local.query_block) : (
      can(regex("^\\s*#", line)) || can(regex("^\\s*\\}", line)) ? "" : (
        length(regexall("^\\s*([_A-Za-z][_0-9A-Za-z]*)", line)) > 0
        ? regexall("^\\s*([_A-Za-z][_0-9A-Za-z]*)", line)[0][1]
        : ""
      )
    )
  ]))

  mutation_fields = distinct(compact([
    for line in split("\n", local.mutation_block) : (
      can(regex("^\\s*#", line)) || can(regex("^\\s*\\}", line)) ? "" : (
        length(regexall("^\\s*([_A-Za-z][_0-9A-Za-z]*)", line)) > 0
        ? regexall("^\\s*([_A-Za-z][_0-9A-Za-z]*)", line)[0][1]
        : ""
      )
    )
  ]))
}

resource "aws_appsync_graphql_api" "this" {
  name                = "${var.app_name}-appsync"
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  schema              = local.schema_contents

  user_pool_config {
    user_pool_id   = var.user_pool_id
    aws_region     = var.aws_region
    default_action = "ALLOW"
  }
}

resource "aws_iam_role" "appsync" {
  name = "${var.app_name}-appsync-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "appsync.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "appsync_lambda" {
  name = "${var.app_name}-appsync-lambda-policy"
  role = aws_iam_role.appsync.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["lambda:InvokeFunction"]
        Resource = var.lambda_function_arn
      }
    ]
  })
}

resource "aws_appsync_datasource" "lambda" {
  api_id           = aws_appsync_graphql_api.this.id
  name             = "${var.app_name}-lambda"
  service_role_arn = aws_iam_role.appsync.arn
  type             = "AWS_LAMBDA"

  lambda_config {
    function_arn = var.lambda_function_arn
  }
}

resource "aws_lambda_permission" "appsync_invoke" {
  statement_id  = "AllowAppSyncInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "appsync.amazonaws.com"
  source_arn    = aws_appsync_graphql_api.this.arn
}

resource "aws_appsync_resolver" "query" {
  for_each   = toset(local.query_fields)
  api_id     = aws_appsync_graphql_api.this.id
  type       = "Query"
  field      = each.value
  data_source = aws_appsync_datasource.lambda.name

  request_template = <<-VTL
  {
    "version": "2017-02-28",
    "operation": "Invoke",
    "payload": $util.toJson($context)
  }
  VTL

  response_template = "$util.toJson($context.result)"
}

resource "aws_appsync_resolver" "mutation" {
  for_each   = toset(local.mutation_fields)
  api_id     = aws_appsync_graphql_api.this.id
  type       = "Mutation"
  field      = each.value
  data_source = aws_appsync_datasource.lambda.name

  request_template = <<-VTL
  {
    "version": "2017-02-28",
    "operation": "Invoke",
    "payload": $util.toJson($context)
  }
  VTL

  response_template = "$util.toJson($context.result)"
}

output "api_id" {
  description = "AppSync API ID."
  value       = aws_appsync_graphql_api.this.id
}

output "graphql_url" {
  description = "AppSync GraphQL URL."
  value       = aws_appsync_graphql_api.this.uris["GRAPHQL"]
}

output "api_arn" {
  description = "AppSync API ARN."
  value       = aws_appsync_graphql_api.this.arn
}
