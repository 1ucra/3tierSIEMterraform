resource "aws_ssm_parameter" "cwagent-config" {
  name        = "/cwagent/config"
  description = "CloudWatch Agent configuration"
  type        = "String"
  value       = file("${path.module}/cwagent_config.json")
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/cwagent-config"
    owner = "ktd-admin"
  }
}

resource "aws_ssm_document" "AmazonCloudWatch-ManageAgent" {
  name          = "AmazonCloudWatch-ManageAgent"
  document_type = "Automation"
  content       = <<EOF
{
  "schemaVersion": "0.3",
  "description": "Install and configure the CloudWatch Agent",
  "mainSteps": [
    {
      "action": "aws:runCommand",
      "name": "runCommand",
      "inputs": {
        "DocumentName": "AmazonCloudWatch-ManageAgent",
        "Parameters": {
          "action": ["configure"],
          "mode": ["ec2"],
          "optionalConfigurationSource": ["ssm"],
          "optionalConfigurationLocation": ["/cwagent/config"],
          "optionalRestart": ["yes"],
          "optionalCleanup": ["yes"]
        }
      }
    }
  ]
}
EOF
}

resource "aws_ssm_association" "cwagent_configure" {
  name           = aws_ssm_document.AmazonCloudWatch-ManageAgent.name
  
  targets    {
      key    = "tag:Name"
      values = ["aws_autoscaling_group/App-ASG", "aws_autoscaling_group/Web-ASG"]
    }
}