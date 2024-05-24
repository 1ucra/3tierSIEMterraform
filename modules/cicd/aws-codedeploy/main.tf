resource "aws_iam_role" "hellowaws-codedeploy-role" {
  name = "hellowaws_codedeploy_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "codedeploy.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_policy" {
  role       = aws_iam_role.hellowaws-codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_iam_role_policy_attachment" "admin_access_policy" {
  role       = aws_iam_role.hellowaws-codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codedeploy_app" "hellowaws_app_deploy" {
  name              = "hellowaws_app_deploy"
  compute_platform  = "Server"
}

# AWS CodeDeploy 배포 그룹 생성
resource "aws_codedeploy_deployment_group" "app_deploy_group" {
  app_name              = aws_codedeploy_app.hellowaws_app_deploy.name
  deployment_group_name = "app_deploy_group"
  service_role_arn      = aws_iam_role.hellowaws-codedeploy-role.arn

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  deployment_config_name = "CodeDeployDefault.HalfAtATime"

  autoscaling_groups = [var.app-autoscalingGroupName]

  load_balancer_info {
    target_group_info {
      name = var.app-targetGroupName
    }
  }

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }
}
