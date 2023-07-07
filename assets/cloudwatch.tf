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
              aws_instance.employee-web-app-a.id,
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "CPUUtilization in AZ A"
        }
      },
      {
        type   = "metric"
        x      = 6
        y      = 0
        width  = 6
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.employee-web-app-b.id,
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "CPUUtilization in AZ B"
        }
      },
    ]
  })
}

resource "aws_cloudwatch_metric_alarm" "employee-web-app-a-alarm" {
  alarm_name = "employee-web-app-a-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 70
  dimensions = {
    InstanceId = aws_instance.employee-web-app-a.id
  }
  alarm_description = "CPUUtilization of employee-web-app-a"
  alarm_actions = [aws_sns_topic.employee-web-app-cpu-alarm.arn]
}

resource "aws_cloudwatch_metric_alarm" "employee-web-app-b-alarm" {
  alarm_name = "employee-web-app-b-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 1
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 300
  statistic = "Average"
  threshold = 70
  dimensions = {
    InstanceId = aws_instance.employee-web-app-b.id
  }
  alarm_description = "CPUUtilization of employee-web-app-b"
  alarm_actions = [aws_sns_topic.employee-web-app-cpu-alarm.arn]
}
