resource "aws_cloudwatch_metric_alarm" "alarm_errors" {
  count             = var.enabled ? 1 : 0
  alarm_name        = "${var.function.function_name}_errors"
  alarm_description = "Lambda Invocation Errors: ${var.function.function_name}"
  namespace         = "AWS/Lambda"
  metric_name       = "Errors"

  # Evaulate metrics by creating datapoints every minute, and alarming if 1 in 5 data points
  # is breaching. This creates an evaluation interval of 5 minutes (5 data points * 1 minute period)
  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "1"
  period              = "60"
  evaluation_periods  = "5"
  datapoints_to_alarm = "1"
  # Treat missing data as ignore. This means the alarm state will be maintained if data is missing
  treat_missing_data = "ignore"

  alarm_actions = [var.sns_topic.arn]
  ok_actions    = [var.sns_topic.arn]

  dimensions = {
    FunctionName = var.function.function_name
    Resource     = var.alias != "" ? "${var.function.function_name}:${var.alias.name}" : var.function.function_name
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alarm_throttles" {
  count             = var.enabled ? 1 : 0
  alarm_name        = "${var.function.function_name}_throttles"
  alarm_description = "Lambda Throttles: ${var.function.function_name}"
  namespace         = "AWS/Lambda"
  metric_name       = "Throttles"

  statistic           = "Sum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "1"  # number of throttled invocations
  period              = "60" # check every - 1 min
  evaluation_periods  = "2"  # send alarm after - 2min
  treat_missing_data  = "notBreaching"

  alarm_actions = [var.sns_topic.arn]
  ok_actions    = [var.sns_topic.arn]

  dimensions = {
    FunctionName = var.function.function_name
    Resource     = var.alias != "" ? "${var.function.function_name}:${var.alias.name}" : var.function.function_name
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alarm_iterator_age" {
  count             = var.enabled && var.enable_iterator_age_alarm ? 1 : 0
  alarm_name        = "${var.function.function_name}_iterator_age"
  alarm_description = "Lambda High Iterator Age: ${var.function.function_name}"
  namespace         = "AWS/Lambda"
  metric_name       = "IteratorAge"

  statistic           = "Maximum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "360000" # max age in milliseconds - 6 minutes
  period              = "60"     # check every - 1 min
  evaluation_periods  = "2"      # send alarm after - 2min

  alarm_actions = [var.sns_topic.arn]
  ok_actions    = [var.sns_topic.arn]

  dimensions = {
    FunctionName = var.function.function_name
    Resource     = var.alias != "" ? "${var.function.function_name}:${var.alias.name}" : var.function.function_name
  }

  tags = local.common_tags
}
