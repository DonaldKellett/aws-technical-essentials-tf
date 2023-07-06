resource "aws_vpc" "employee-web-app-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "employee-web-app-vpc"
  }
}

resource "aws_subnet" "employee-web-app-a-ec2-subnet" {
  vpc_id = aws_vpc.employee-web-app-vpc.id
  availability_zone = "${var.region}a"
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "employee-web-app-a-ec2-subnet"
  }
}

resource "aws_subnet" "employee-web-app-b-ec2-subnet" {
  vpc_id = aws_vpc.employee-web-app-vpc.id
  availability_zone = "${var.region}b"
  cidr_block = "10.1.2.0/24"
  tags = {
    Name = "employee-web-app-b-ec2-subnet"
  }
}

resource "aws_subnet" "employee-web-app-a-db-subnet" {
  vpc_id = aws_vpc.employee-web-app-vpc.id
  availability_zone = "${var.region}a"
  cidr_block = "10.1.3.0/24"
  tags = {
    Name = "employee-web-app-a-db-subnet"
  }
}

resource "aws_subnet" "employee-web-app-b-db-subnet" {
  vpc_id = aws_vpc.employee-web-app-vpc.id
  availability_zone = "${var.region}b"
  cidr_block = "10.1.4.0/24"
  tags = {
    Name = "employee-web-app-b-db-subnet"
  }
}

resource "aws_internet_gateway" "employee-web-app-vpc-igw" {
  vpc_id = aws_vpc.employee-web-app-vpc.id
  tags = {
    Name = "employee-web-app-vpc-igw"
  }
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "employee-web-app-sg" {
  name        = "employee-web-app-sg"
  description = "Security group for employee web app"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
