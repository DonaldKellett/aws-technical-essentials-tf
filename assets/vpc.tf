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

resource "aws_route_table" "employee-web-app-public-rtb" {
  vpc_id = aws_vpc.employee-web-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.employee-web-app-vpc-igw.id
  }

  tags = {
    Name = "employee-web-app-public-rtb"
  }
}

resource "aws_route_table_association" "employee-web-app-public-rtba-a" {
  subnet_id = aws_subnet.employee-web-app-a-ec2-subnet.id
  route_table_id = aws_route_table.employee-web-app-public-rtb.id
}

resource "aws_route_table_association" "employee-web-app-public-rtba-b" {
  subnet_id = aws_subnet.employee-web-app-b-ec2-subnet.id
  route_table_id = aws_route_table.employee-web-app-public-rtb.id
}

resource "aws_security_group" "employee-web-app-lb-sg" {
  name        = "employee-web-app-lb-sg"
  description = "Security group for employee web app load balancer"
  vpc_id      = aws_vpc.employee-web-app-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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

resource "aws_security_group" "employee-web-app-ec2-sg" {
  name        = "employee-web-app-ec2-sg"
  description = "Security group for employee web app EC2 instances"
  vpc_id      = aws_vpc.employee-web-app-vpc.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.employee-web-app-lb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
