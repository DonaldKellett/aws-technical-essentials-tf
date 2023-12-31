variable "region" {
  type = string
  default = "ap-east-1"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

output "employee-web-app-endpoint" {
  value = aws_lb.employee-web-app-lb.dns_name
}
