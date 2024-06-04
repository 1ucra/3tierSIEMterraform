
# Creating Launch template for App tier AutoScaling Group!
resource "aws_launch_template" "App-LC" {
  name = "App-template"
  image_id = var.ami-id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.app-securityGroup-id]
  
  # user_data = base64encode(templatefile("${path.module}/app_userdata2.sh", {
  # }))
}


resource "aws_autoscaling_group" "App-ASG" {
  name = var.app_asg_name
  vpc_zone_identifier  = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
  launch_template {
    id = aws_launch_template.App-LC.id
    version = aws_launch_template.App-LC.latest_version
  }
  min_size             = 2
  max_size             = 6
  health_check_type    = "ELB"
  health_check_grace_period = 300
  target_group_arns    = [var.app-targetGroup-arn]
  force_delete         = true
  
  metrics_granularity = "1Minute"
    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupPendingInstances",
      "GroupStandbyInstances",
      "GroupTerminatingInstances",
      "GroupTotalInstances"
    ]
  
  tag {
    key                 = "Name"
    value               = "App-ASG"
    propagate_at_launch = true
  }

}



# Creating Launch template for Web tier AutoScaling Group!
resource "aws_launch_template" "Web-LC" {
  name = "Web-template"
  image_id = var.ami-id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.web-securityGroup-id]

  user_data = base64encode(templatefile("${path.module}/web_userdata.sh", {
    app_lb_dns = var.app_alb_dns_name
  }))


  depends_on = [ aws_autoscaling_group.App-ASG ]
}


resource "aws_autoscaling_group" "Web-ASG" {
  name = var.web_asg_name
  vpc_zone_identifier  = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
  launch_template {
    id = aws_launch_template.Web-LC.id
    version = aws_launch_template.Web-LC.latest_version
  }
  min_size             = 2
  max_size             = 4
  health_check_type    = "ELB"
  health_check_grace_period = 300
  target_group_arns    = [var.web-targetGroup-arn]
  force_delete         = true

  metrics_granularity = "1Minute"
    enabled_metrics = [
      "GroupMinSize",
      "GroupMaxSize",
      "GroupDesiredCapacity",
      "GroupInServiceInstances",
      "GroupPendingInstances",
      "GroupStandbyInstances",
      "GroupTerminatingInstances",
      "GroupTotalInstances"
    ]

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
      max_healthy_percentage = 200
      instance_warmup        = 180
    }
  }

  tag {
    key                 = "Name"
    value               = "Web-ASG"
    propagate_at_launch = true
  }

  
}

