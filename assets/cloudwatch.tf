resource "aws_cloudwatch_dashboard" "employee-web-app-dashboard" {
  dashboard_name = "employee-web-app-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 6
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.employee-web-app.id,
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "CPUUtilization"
        }
      },
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "employee-web-app-alarm" {
  alarm_name = "employee-web-app-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 70
  dimensions = {
    InstanceId = aws_instance.employee-web-app.id
  }
  alarm_description = "CPUUtilization of employee-web-app"
  alarm_actions = [aws_sns_topic.employee-web-app-cpu-alarm.arn]
}
