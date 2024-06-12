resource "aws_iam_role" "iam-role" {
  name               = var.iam_role
  assume_role_policy = file("${path.module}/iam-role.json")
}

resource "aws_iam_role" "codebuild-role" {
  name = "codebuild-hellowaws_3teir_buildProject-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}