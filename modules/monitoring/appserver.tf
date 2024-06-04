
# resource "aws_autoscaling_policy" "app-custom-cpu-policy" {
#   name                   = "custom-cpu-policy"
#   autoscaling_group_name = aws_autoscaling_group.App-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }


# resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm" {
#   alarm_name          = "custom-webserver-cpu-alarm"
#   alarm_description   = "alarm when cpu usage increases"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "85"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy.arn]
# }


# resource "aws_autoscaling_policy" "app-custom-cpu-policy-scaledown" {
#   name                   = "custom-cpu-policy-scaledown"
#   autoscaling_group_name = aws_autoscaling_group.App-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "app-custom-cpu-alarm-scaledown" {
#   alarm_name          = "custom-appserver-cpu-alarm-scaledown"
#   alarm_description   = "alarm when cpu usage decreases"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "20"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.App-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.app-custom-cpu-policy-scaledown.arn]
# }
