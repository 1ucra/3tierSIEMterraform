resource "aws_iam_role" "codebuild-role" {
  name = "hellowaws_codebuild_role_name"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_security_group" "allow-all" {
  name        = "allow_all_traffic"
  description = "Security group with no filtering, allows all inbound and outbound traffic"
  vpc_id      = var.vpc-id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_security_group/allow-all"
    owner = "ktd-admin"
  }
}

resource "aws_iam_role_policy_attachment" "codebuild-role-policy" {
  role       = aws_iam_role.codebuild-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "hellowaws-3teir-buildProject" {
  name           = "hellowaws_3teir_buildProject"
  description    = "hellowaws_3teir_buildProject"
  build_timeout  = 40
  queued_timeout = 180

  concurrent_build_limit = 2

  badge_enabled = true

  source {
    type            = "CODECOMMIT"
    location        = var.repository_name
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  environment {
    type                = "LINUX_CONTAINER"
    image               = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    compute_type        = "BUILD_GENERAL1_SMALL"
    
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "ca-central-1"
    }

    environment_variable {
      name  = "REPOSITORY_NAME"
      value = var.repository_name
    }

    privileged_mode = true

  }

  service_role = aws_iam_role.codebuild-role.arn

  artifacts {
    type  = "S3"
    location = var.s3_artifact_bucket_id
    path                = "hellowaws-cicd/build_output"
    packaging = "NONE"
    encryption_disabled = true
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  vpc_config {
    vpc_id          = var.vpc-id
    subnets         = [var.subnet1-id,var.subnet2-id]
    security_group_ids = [aws_security_group.allow-all.id]
  }
}