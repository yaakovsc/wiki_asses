output "alarm_arns" {
  value = [
    aws_cloudwatch_metric_alarm.ecs_cpu.arn,
    aws_cloudwatch_metric_alarm.alb_5xx.arn
  ]
}