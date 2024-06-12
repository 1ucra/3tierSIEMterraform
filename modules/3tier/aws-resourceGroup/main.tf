resource "aws_resourcegroups_group" "app-asg-resourceGroup" {
  name        = "AppSever-resourceGroup"
  description = "Resource group for EC2 instances in the APP Auto Scaling Group"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = [
        "AWS::EC2::Instance"
      ]
      TagFilters = [
        {
          Key = "Name"
          Values = ["aws_autoscaling_group/App-ASG"]
        }
      ]
    })
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_resourcegroups_group/app-asg-resourceGroup"
    owner = "ktd-admin"
  }
}

resource "aws_resourcegroups_group" "web-asg-resourceGroup" {
  name        = "WebSever-resourceGroup"
  description = "Resource group for EC2 instances in the WEB Auto Scaling Group"

  resource_query {
    query = jsonencode({
      ResourceTypeFilters = [
        "AWS::EC2::Instance"
      ]
      TagFilters = [
        {
          Key = "Name"
          Values = ["aws_autoscaling_group/Web-ASG"]
        }
      ]
    })
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_resourcegroups_group/web-asg-resourceGroup"
    owner = "ktd-admin"
  }
}

