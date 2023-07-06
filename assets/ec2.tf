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

resource "aws_instance" "employee-web-app" {
  ami = data.aws_ami.al2023.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.employee-web-app-sg.id
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
export PHOTOS_BUCKET=$${SUB_PHOTOS_BUCKET}
export AWS_DEFAULT_REGION=${var.region}
export DYNAMO_MODE=on
FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
EOT
  tags = {
    Name = "employee-web-app"
  }
}
