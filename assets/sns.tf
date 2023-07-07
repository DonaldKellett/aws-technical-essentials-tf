resource "aws_sns_topic" "employee-web-app-cpu-alarm" {
  name = "employee-web-app-cpu-alarm"
}

resource "aws_sns_topic_subscription" "employee-web-app-cpu-alarm-subscription" {
  topic_arn = aws_sns_topic.employee-web-app-cpu-alarm.arn
  protocol = "email"
  endpoint = var.email
}
