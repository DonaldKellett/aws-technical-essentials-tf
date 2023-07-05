resource "aws_iam_role" "S3DynamoDBFullAccessRole" {
  name = "S3DynamoDBFullAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "S3DynamoDBFullAccessRoleS3PolicyAttachment" {
  role = aws_iam_role.S3DynamoDBFullAccessRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "S3DynamoDBFullAccessRoleDynamoDBPolicyAttachment" {
  role = aws_iam_role.S3DynamoDBFullAccessRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_instance_profile" "employee-web-app-profile" {
  name = "employee-web-app-profile"
  role = aws_iam_role.S3DynamoDBFullAccessRole.name
}
