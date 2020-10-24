data "aws_sns_topic" "alarm_sns_topic" {
  count = var.enable_alarms ? 1 : 0
  name  = var.alarm_sns_topic
}

resource "aws_cloudwatch_metric_alarm" "dynamodb_throttled_notification" {
  count               = var.enable_alarms ? 1 : 0
  alarm_name          = "${aws_dynamodb_table.dynamodb_table.name}_THROTTLED"
  comparison_operator = "GreaterThanThreshold"
  period              = var.alarm_period
  metric_name         = "ThrottledRequests"
  evaluation_periods  = var.alarm_evaluation_period
  namespace           = "AWS/DynamoDB"
  statistic           = "Sum"
  threshold           = var.alarm_threshold

  alarm_description = <<EOF
Read or write requests to a critical DynamoDB table are being throttled.
  - Check the ReadThrottleEvents and WriteThrottleEvents Dynamo metrics on each GSI to understand which
    operation is causing throttles.
  - If this is normal/expected behavior, increase the dynamo_read_capacity in the tables configuration.
EOF


  treat_missing_data = "notBreaching"

  ok_actions = [data.aws_sns_topic.alarm_sns_topic[0].arn]
  alarm_actions = [data.aws_sns_topic.alarm_sns_topic[0].arn]

  dimensions = {
    TableName = aws_dynamodb_table.dynamodb_table.name
  }
}

