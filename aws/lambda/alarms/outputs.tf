output "alarm_errors" {
  value = aws_cloudwatch_metric_alarm.alarm_errors
}

output "alarm_throttles" {
  value = aws_cloudwatch_metric_alarm.alarm_throttles
}
