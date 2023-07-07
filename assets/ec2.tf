data "aws_ami" "al2023" {
  most_recent = true
  
  filter {
    name = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "employee-web-app-a" {
  ami = data.aws_ami.al2023.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.employee-web-app-ec2-sg.id
  ]
  subnet_id = aws_subnet.employee-web-app-a-ec2-subnet.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.employee-web-app-profile.name
  user_data = <<EOT
#!/bin/bash -ex
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
unzip FlaskApp.zip
cd FlaskApp/
yum -y install python3-pip
pip install -r requirements.txt
yum -y install stress
export PHOTOS_BUCKET=${aws_s3_bucket.employee-photo-bucket.bucket}
export AWS_DEFAULT_REGION=${var.region}
export DYNAMO_MODE=on
FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
EOT
  tags = {
    Name = "employee-web-app-a"
  }
}

resource "aws_instance" "employee-web-app-b" {
  ami = data.aws_ami.al2023.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.employee-web-app-ec2-sg.id
  ]
  subnet_id = aws_subnet.employee-web-app-b-ec2-subnet.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.employee-web-app-profile.name
  user_data = <<EOT
#!/bin/bash -ex
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
unzip FlaskApp.zip
cd FlaskApp/
yum -y install python3-pip
pip install -r requirements.txt
yum -y install stress
export PHOTOS_BUCKET=${aws_s3_bucket.employee-photo-bucket.bucket}
export AWS_DEFAULT_REGION=${var.region}
export DYNAMO_MODE=on
FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
EOT
  tags = {
    Name = "employee-web-app-b"
  }
}

resource "aws_launch_template" "employee-web-app-lt" {
  name = "employee-web-app-lt"
  image_id = data.aws_ami.al2023.id
  instance_type = var.instance_type
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.employee-web-app-ec2-sg.id]
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.employee-web-app-profile.arn
  }
  user_data = base64encode(<<EOT
#!/bin/bash -ex
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
unzip FlaskApp.zip
cd FlaskApp/
yum -y install python3-pip
pip install -r requirements.txt
yum -y install stress
export PHOTOS_BUCKET=${aws_s3_bucket.employee-photo-bucket.bucket}
export AWS_DEFAULT_REGION=${var.region}
export DYNAMO_MODE=on
FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
EOT
  )
  tags = {
    Name = "employee-web-app"
  }
}

resource "aws_lb" "employee-web-app-lb" {
  name               = "employee-web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.employee-web-app-lb-sg.id]
  subnets            = [
    aws_subnet.employee-web-app-a-ec2-subnet.id,
    aws_subnet.employee-web-app-b-ec2-subnet.id,
  ]
}

resource "aws_lb_target_group" "employee-web-app-lb-tg" {
  name = "employee-web-app-lb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.employee-web-app-vpc.id
}

resource "aws_lb_target_group_attachment" "employee-web-app-lb-tga-a" {
  target_group_arn = aws_lb_target_group.employee-web-app-lb-tg.arn
  target_id = aws_instance.employee-web-app-a.id
  port = 80
}

resource "aws_lb_target_group_attachment" "employee-web-app-lb-tga-b" {
  target_group_arn = aws_lb_target_group.employee-web-app-lb-tg.arn
  target_id = aws_instance.employee-web-app-b.id
  port = 80
}

resource "aws_lb_listener" "employee-web-app-lb-listener" {
  load_balancer_arn = aws_lb.employee-web-app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.employee-web-app-lb-tg.arn
  }
}
