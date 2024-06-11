
# resource "aws_autoscaling_policy" "web-custom-cpu-policy" {
#   name                   = "custom-cpu-policy"
#   autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = 1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }


# resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm" {
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


# resource "aws_autoscaling_policy" "web-custom-cpu-policy-scaleIn" {
#   name                   = "custom-cpu-policy-scaleIn"
#   autoscaling_group_name = aws_autoscaling_group.Web-ASG.id
#   adjustment_type        = "ChangeInCapacity"
#   scaling_adjustment     = -1
#   cooldown               = 60
#   policy_type            = "SimpleScaling"
# }

# resource "aws_cloudwatch_metric_alarm" "web-custom-cpu-alarm-scaleIn" {
#   alarm_name          = "custom-webserver-cpu-alarm-scaleIn"
#   alarm_description   = "alarm when cpu usage decreases"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = 2
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = 120
#   statistic           = "Average"
#   threshold           = "20"

#   dimensions = {
#     "AutoScalingGroupName" : aws_autoscaling_group.Web-ASG.name
#   }
#   actions_enabled = true

#   alarm_actions = [aws_autoscaling_policy.web-custom-cpu-policy-scaleIn.arn]
# }
