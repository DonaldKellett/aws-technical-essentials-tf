resource "aws_iam_role" "EmployeeWebAppRole" {
  name = "EmployeeWebAppRole"

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

resource "aws_iam_role_policy_attachment" "EmployeeWebAppRoleS3PolicyAttachment" {
  role = aws_iam_role.EmployeeWebAppRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "EmployeeWebAppRoleDynamoDBPolicyAttachment" {
  role = aws_iam_role.EmployeeWebAppRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
