
# Creating ALB for App Tier
resource "aws_lb" "App-elb" {
  name = var.app-alb-name
  internal           = true
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.private-subnet1.id, data.aws_subnet.private-subnet2.id]
  security_groups    = [data.aws_security_group.app-alb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = var.app-alb-name
  }
}

# Creating Target Group for App-Tier 
resource "aws_lb_target_group" "app-tg" {
  #name = var.app-tg-name
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
    Name = var.app-tg-name
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
  name = var.web-alb-name
  internal           = false
  load_balancer_type = "application"
  subnets            = [data.aws_subnet.public-subnet1.id, data.aws_subnet.public-subnet2.id]
  security_groups    = [data.aws_security_group.web-alb-sg.id]
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
  tags = {
    Name = var.web-alb-name
  }
}

# Creating Target Group for Web-Tier 
resource "aws_lb_target_group" "web-tg" {
  #name = var.web-tg-name
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
    Name = var.web-tg-name
  }
}


# Creating ALB listener with port 80 and attaching it to Web-Tier Target Group
resource "aws_lb_listener" "web-alb-listener" {
  load_balancer_arn = aws_lb.Web-elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

