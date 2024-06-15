
# Creating Launch template for App tier AutoScaling Group!
resource "aws_launch_template" "App-LC" {
  name = "App-template"
  image_id = var.my-ami-id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/app_userdata.sh", {
      
  }))

  vpc_security_group_ids = [var.app-securityGroup-id]
  
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_launch_template/App-LC"
    owner = "ktd-admin"
  }
}


resource "aws_autoscaling_group" "App-ASG" {
  name = var.app_asg_name
  vpc_zone_identifier  = [data.aws_subnet.private-subnet1.id, data.aws_subnet.private-subnet2.id]
  
  launch_template {
    id = aws_launch_template.App-LC.id
    version = "$Default"
  }
  
  min_size             = 2
  max_size             = 6
  health_check_type    = "ELB"
  health_check_grace_period = 300
  target_group_arns    = [var.app-targetGroup-arn]
  force_delete         = true
  
  metrics_granularity = "5Minute"
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
  

  warm_pool {
    min_size                 = 1
    max_group_prepared_capacity = 3
    pool_state               = "Stopped"
  }

  tag {
    key                 = "Name"
    value               = "aws_autoscaling_group/App-ASG"
    propagate_at_launch = true
  }
}



# Creating Launch template for Web tier AutoScaling Group!
resource "aws_launch_template" "Web-LC" {
  name = "Web-template"
  image_id = var.my-ami-id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [var.web-securityGroup-id]

  user_data = base64encode(templatefile("${path.module}/web_userdata.sh", {
    app_lb_dns = var.app_elb_dns_name,
    repository_name = var.repository_name
  }))


  depends_on = [ aws_autoscaling_group.App-ASG ]
}


resource "aws_autoscaling_group" "Web-ASG" {
  name = var.web_asg_name
  vpc_zone_identifier  = [data.aws_subnet.private-subnet1.id, data.aws_subnet.private-subnet2.id]
  launch_template {
    id = aws_launch_template.Web-LC.id
    version = "$Default"
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

  warm_pool {
    min_size                 = 1
    max_group_prepared_capacity = 3
    pool_state               = "Stopped"
  }

  tag {
    key                 = "Name"
    value               = "aws_autoscaling_group/Web-ASG"
    propagate_at_launch = true
  }
  
}


resource "aws_autoscaling_policy" "app-custom-cpu-policy-scaleOut" {
  name                   = "custom-appserver-cpu-policy-scaleOut"
  autoscaling_group_name = aws_autoscaling_group.App-ASG.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm-scaleOut" {
  alarm_name          = "custom-appserver-cpu-alarm-scaleOut"
  alarm_description   = "alarm when cpu usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.App-ASG.name
  }
  actions_enabled = true

  alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy-scaleOut.arn]
}

resource "aws_autoscaling_policy" "web-custom-cpu-policy-scaleOut" {
  name                   = "custom-webserver-cpu-policy-scaleOut"
  autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}


resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm-scaleOut" {
  alarm_name          = "custom-webserver-cpu-alarm-scaleOut"
  alarm_description   = "alarm when cpu usage increases"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
  }
  actions_enabled = true

  alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy-scaleOut.arn]
}

resource "aws_autoscaling_policy" "app-custom-cpu-policy-scaleIn" {
  name                   = "custom-appserver-cpu-policy-scaleIn"
  autoscaling_group_name = aws_autoscaling_group.App-ASG.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm-scaleIn" {
  alarm_name          = "custom-appserver-cpu-alarm-scaleIn"
  alarm_description   = "alarm when cpu usage decreases"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.App-ASG.name
  }
  actions_enabled = true

  alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy-scaleIn.arn]
}



resource "aws_autoscaling_policy" "web-custom-cpu-policy-scaleIn" {
  name                   = "custom-webserver-cpu-policy-scaleIn"
  autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm-scaleIn" {
  alarm_name          = "custom-webserver-cpu-alarm-scaleIn"
  alarm_description   = "alarm when cpu usage decreases"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
  }
  actions_enabled = true

  alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy-scaleIn.arn]
}
