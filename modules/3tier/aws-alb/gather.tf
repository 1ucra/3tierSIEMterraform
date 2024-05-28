data "aws_subnet" "public_subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name1]
  }
}

data "aws_subnet" "public_subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.public_subnet_name2]
  }
}

data "aws_subnet" "private_subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name1]
  }
}

data "aws_subnet" "private_subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.private_subnet_name2]
  }
}

data "aws_security_group" "web-alb-sg" {
  filter {
    name   = "tag:Name"
    values = [var.web_alb_securityGroup_name]
  }
  filter {
    name = "group-id"
    values = [var.web_alb_securityGroup_id]
  }
}

data "aws_security_group" "app-alb-sg" {
  filter {
    name   = "tag:Name"
    values = [var.app_alb_securityGroup_name]
  }
  filter {
    name = "group-id"
    values = [var.app_alb_securityGroup_id]
  }
}


data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}