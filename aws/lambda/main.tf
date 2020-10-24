resource "aws_lambda_function" "function" {
  # Metadata
  function_name = var.function_name
  description   = var.description

  # Source code
  filename = var.filename

  # Lambda exec details
  handler     = var.handler
  runtime     = var.runtime
  memory_size = var.memory_size
  timeout     = var.timeout

  # Security
  role        = var.lambda_iam_role.arn
  kms_key_arn = var.kms_key != null ? var.kms_key.arn : ""

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [""] : [] # create only one dynamic block
    content {
      subnet_ids         = var.vpc_config.subnet_ids
      security_group_ids = var.vpc_config.security_groups.*.id
    }
  }

  # Logging / Errors
  tracing_config {
    mode = var.tracing_mode
  }

  # Vars & Tags
  dynamic "environment" {
    for_each = var.env_vars != null ? [""] : [] # create only one dynamic block
    content {
      variables = var.env_vars
    }
  }

  tags = local.common_tags

  lifecycle {
    ignore_changes = [
      last_modified,
      filename,
    ]
  }

  depends_on = [aws_cloudwatch_log_group.log_group]
}

# manage log group to set retention
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days

  tags = local.common_tags
}
