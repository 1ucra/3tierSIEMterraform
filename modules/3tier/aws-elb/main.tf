
# Creating elb for App Tier
resource "aws_lb" "App-elb" {
  name = var.app_elb_name
  internal           = true
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.private-subnet1.id, data.aws_subnet.private-subnet2.id]
  security_groups    = [data.aws_security_group.app-elb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_lb/App-elb"
    owner = "ktd-admin"
  }
}

# Creating Target Group for App-Tier 
resource "aws_lb_target_group" "app-tg" {
  name = "${var.app_tg_name}${formatdate("YYYYMMDD-HHmm", timestamp())}"
  health_check {
    enabled = true
    interval            = 30
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  deregistration_delay = 60

  target_type = "instance"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.hellowaws-vpc.id

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_lb_target_group/app-tg"
    owner = "ktd-admin"
  }
}


# Creating elb listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "app-elb-listener" {
  load_balancer_arn = aws_lb.App-elb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_lb_listener/app-elb-listener"
    owner = "ktd-admin"
  }
}

# Creating elb for Web Tier
resource "aws_lb" "Web-elb" {
  name = var.web_elb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
  security_groups    = [data.aws_security_group.web-elb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_lb/Web-elb"
    owner = "ktd-admin"
  }
}

# Creating Target Group for Web-Tier 
resource "aws_lb_target_group" "web-tg" {
  name = "${var.web_tg_name}${formatdate("YYYYMMDD-HHmm", timestamp())}"
  health_check {
    enabled = true
    interval            = 30
    path                = "/healthcheck"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.hellowaws-vpc.id

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_lb_target_group/web-tg"
    owner = "ktd-admin"
  }
}


# Creating elb listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "web-elb-listener" {
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

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_lb_listener/web-elb-listener"
    owner = "ktd-admin"
  }
}

resource "aws_lb_listener_rule" "web-listener-rule" {
  listener_arn = aws_lb_listener.web-elb-listener.arn
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

resource "aws_ssm_parameter" "app-elb-dns" {
  name  = "/config/system/elb_dns_name"
  type  = "String"
  value = aws_lb.App-elb.dns_name

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_ssm_parameter/app-elb-dns"
    owner = "ktd-admin"
  }
}

