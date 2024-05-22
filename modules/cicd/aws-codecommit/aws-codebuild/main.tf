
resource "aws_iam_role_policy_attachment" "codebuild_role_policy" {
  role       = data.aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_codebuild_project" "hellowaws_3teir_buildProject" {
  name          = "hellowaws_3teir_buildProject"
  description   = "CodeBuild project for hellowaws 3-tier architecture"
  build_timeout = 40
  queued_timeout = 180

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/hellowaws"
    buildspec       = "buildspec.yml"
    git_clone_depth = 1
    git_submodules_config {
      fetch_submodules = false
    }
    report_build_status = true
    insecure_ssl        = false
  }

  artifacts {
    type               = "S3"
    location           = "hellowaws-artifact-bucket"
    path               = "artifacts"
    packaging          = "NONE"
    encryption_disabled = true
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"
  }

  service_role = data.aws_iam_role.codebuild_role.arn

  logs_config {
    cloudwatch_logs {
      status = "DISABLED"
    }
    s3_logs {
      status             = "ENABLED"
      location           = "hellowaws-logs-bucket"
      encryption_disabled = true
      bucket_owner_access = "READ_ONLY"
    }
  }

  vpc_config {
    vpc_id           = "vpc-xxxxxxxx" # 실제 VPC ID로 변경하세요.
    subnets          = ["subnet-xxxxxxxx"] # 실제 서브넷 ID로 변경하세요.
    security_group_ids = ["sg-xxxxxxxx"] # 실제 보안 그룹 ID로 변경하세요.
  }

  badge_enabled = true
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.hellowaws_3teir_buildProject.arn
}
