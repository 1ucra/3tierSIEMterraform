resource "aws_ssm_parameter" "cwagent-config" {
  name        = "/cwagent/config"
  description = "CloudWatch Agent configuration"
  type        = "String"
  overwrite   = true
  value       = file("${path.module}/cwagent_config.json")
  
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/cwagent-config"
    owner = "ktd-admin"
  }
}


resource "aws_ssm_association" "cwagent_configure" {
  name           = "AmazonCloudWatch-ManageAgent"
  
  targets    {
      key    = "tag:Name"
      values = ["aws_autoscaling_group/App-ASG", "aws_autoscaling_group/Web-ASG"]
    }

  parameters = {
    action                        = "configure"
    mode                          = "ec2"
    optionalConfigurationSource   = "ssm"
    optionalConfigurationLocation = "/cwagent/config"
    optionalRestart               = "yes"
  }

}