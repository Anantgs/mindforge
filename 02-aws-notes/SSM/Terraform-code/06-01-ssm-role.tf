# Create an IAM policy
resource "aws_iam_policy" "ssm_iam_policy" {
  name = var.iam_policy_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          # "ssm:StartSession",
          # "ssm:TerminateSession",
          # "ssm:DescribeSessions",
          # "ssm:GetConnectionStatus"
          "ssm:GetConnectionStatus",
          "ssm:DescribeSessions",
          "ssm:*",
          "ec2messages:*",
          "ssmmessages:*",
          "ssm:TerminateSession",
          "ssm:StartSession"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create an IAM role
resource "aws_iam_role" "ssm_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the IAM policy to the IAM role
resource "aws_iam_policy_attachment" "ssm_role_policy_attachment" {
  name = "Policy Attachement"
  policy_arn = aws_iam_policy.ssm_iam_policy.arn
  roles       = [aws_iam_role.ssm_role.name]
}

# Create an IAM instance profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.ssm_role.name
}

