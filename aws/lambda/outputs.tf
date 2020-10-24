output "lambda" {
  description = "The Lambda Function."
  value       = aws_lambda_function.function
}

output "log_group" {
  description = "The log group associated with this lambda function"
  value       = aws_cloudwatch_log_group.log_group
}
