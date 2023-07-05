resource "aws_instance" "employee-web-app" {
  ami = "ami-06098e58989d56f7d"
  instance_type = "t3.micro"
  vpc_security_group_ids = [
    aws_security_group.employee-web-app-sg.id
  ]
  iam_instance_profile = aws_iam_instance_profile.employee-web-app-profile.name
  user_data = <<EOT
#!/bin/bash -ex
wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/DEV-AWS-MO-GCNv2/FlaskApp.zip
unzip FlaskApp.zip
cd FlaskApp/
yum -y install python3-pip
pip install -r requirements.txt
yum -y install stress
export PHOTOS_BUCKET=$\{SUB_PHOTOS_BUCKET\}
export AWS_DEFAULT_REGION=ap-east-1
export DYNAMO_MODE=on
FLASK_APP=application.py /usr/local/bin/flask run --host=0.0.0.0 --port=80
EOT
}
