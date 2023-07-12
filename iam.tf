resource "aws_iam_user" "clops-user" {
  name = "clops1-user"
  path = "/"

  tags = {
    Name = "clops-user"
  }
}

resource "aws_iam_user_policy" "s3-full-access-policy" {
  name   = "s3-full-access-policy"
  user   = aws_iam_user.clops-user.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
EOF
}
