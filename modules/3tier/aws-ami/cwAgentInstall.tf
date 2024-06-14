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
      values = ["aws_instance/bastion"]
    }

  parameters = {
    action                        = "configure"
    mode                          = "ec2"
    optionalConfigurationSource   = "ssm"
    optionalConfigurationLocation = "/cwagent/config"
    optionalRestart               = "yes"
  }

  depends_on = [ aws_instance.bastion ]
}