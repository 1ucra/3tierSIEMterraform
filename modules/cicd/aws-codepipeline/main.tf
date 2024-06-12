# IAM 역할 생성 및 Admin Access 정책 부여
resource "aws_iam_role" "hellowaws-codepipeline-role" {
  name = "hellowaws_codepipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline-policy-attachment" {
  role       = aws_iam_role.hellowaws-codepipeline-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# CodePipeline 생성
resource "aws_codepipeline" "hellowaw-cicd" {
  name     = "hellowaws-cicd"
  role_arn = aws_iam_role.hellowaws-codepipeline-role.arn

  artifact_store {
    type     = "S3"
    location = var.artifact-bucket-name
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.repository-name
        BranchName     = "main"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "hellowaws_3teir_buildProject"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "CodeDeploy"
      version          = "1"
      input_artifacts  = ["build_output"]

      configuration = {
        ApplicationName = "hellowaws_app_deploy"
        DeploymentGroupName = "first_app_deploy_group"
      }
    }
  }
}

# EventBridge가 사용할 IAM 역할 생성
resource "aws_iam_role" "eventbridge-role" {
  name = "hellowaws_eventbridge_codepipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge-role-policy" {
  role = aws_iam_role.eventbridge-role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "codepipeline:StartPipelineExecution"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Events 규칙을 생성하여 CodePipeline 트리거
resource "aws_cloudwatch_event_rule" "codepipeline-trigger-rule" {
  name        = "CodePipelineTriggerRule"
  description = "Trigger CodePipeline on CodeCommit push"
  event_pattern = jsonencode({
    "source": [
      "aws.codecommit"
    ],
    "detail-type": [
      "CodeCommit Repository State Change"
    ],
    "resources": [
      "${var.repository-arn}"
    ],
    "detail": {
      "event": [
        "referenceUpdated"
      ],
      "referenceType": [
        "branch"
      ],
      "referenceName": [
        "main"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "codepipeline-trigger-target" {
  rule = aws_cloudwatch_event_rule.codepipeline-trigger-rule.name
  target_id = "CodePipeline"
  arn = aws_codepipeline.hellowaw-cicd.arn
  role_arn  = aws_iam_role.eventbridge-role.arn
}