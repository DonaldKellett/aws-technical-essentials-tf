resource "aws_s3_bucket" "employee-photo-bucket" {
  bucket = "employee-photo-bucket-${random_id.s3-suffix.hex}"
  force_destroy = true
  tags = {
    Name = "employee-photo-bucket"
  }
}

resource "aws_s3_bucket_policy" "employee-photo-bucket-policy" {
  bucket = aws_s3_bucket.employee-photo-bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowS3ReadAccess"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.S3DynamoDBFullAccessRole.arn
        }
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.employee-photo-bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.employee-photo-bucket.bucket}/*",
        ]
      },
    ]
  })
}
