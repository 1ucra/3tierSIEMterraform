
# Creating ALB for App Tier
resource "aws_lb" "App-elb" {
  name = var.app_alb_name
  internal           = true
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.private_subnet1.id, data.aws_subnet.private_subnet2.id]
  security_groups    = [data.aws_security_group.app-alb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = var.app_alb_name
  }
}

# Creating Target Group for App-Tier 
resource "aws_lb_target_group" "app-tg" {
  name = "${var.app_tg_name}${formatdate("YYYYMMDD-HHmm", timestamp())}"
  health_check {
    enabled = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  target_type = "instance"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name = var.app_tg_name
  }
}


# Creating ALB listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "app-alb-listener" {
  load_balancer_arn = aws_lb.App-elb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}

# Creating ALB for Web Tier
resource "aws_lb" "Web-elb" {
  name = var.web_alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public_subnet1.id, data.aws_subnet.public_subnet2.id]
  security_groups    = [data.aws_security_group.web-alb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = var.web_alb_name
  }
}

# Creating Target Group for Web-Tier 
resource "aws_lb_target_group" "web-tg" {
  name = "${var.web_tg_name}${formatdate("YYYYMMDD-HHmm", timestamp())}"
  health_check {
    enabled = true
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name = var.web_tg_name
  }
}


# Creating ALB listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.Web-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden. Only accessible through the cloud front"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "web-listener-rule" {
  listener_arn = aws_lb_listener.web-alb-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }

  condition {
    http_header {
      http_header_name = var.header_name
      values           = [var.header_value]
    }
  }
}

resource "aws_ssm_parameter" "app-alb-dns" {
  name  = "/config/system/alb_dns_name"
  type  = "String"
  value = aws_lb.App-elb.dns_name

  tags = {
    Name = "AppALBDNS"
  }
}

