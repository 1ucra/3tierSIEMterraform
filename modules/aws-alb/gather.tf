data "aws_subnet" "public-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.public-subnet-name1]
  }
}

data "aws_subnet" "public-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.public-subnet-name2]
  }
}

data "aws_subnet" "private-subnet1" {
  filter {
    name   = "tag:Name"
    values = [var.private-subnet-name1]
  }
}

data "aws_subnet" "private-subnet2" {
  filter {
    name   = "tag:Name"
    values = [var.private-subnet-name2]
  }
}

data "aws_security_group" "web-alb-sg" {
  filter {
    name   = "tag:Name"
    values = [var.web-alb-sg-name]
  }
  filter {
    name = "group-id"
    values = [var.web-alb-sg-id]
  }
}

data "aws_security_group" "app-alb-sg" {
  filter {
    name   = "tag:Name"
    values = [var.app-alb-sg-name]
  }
  filter {
    name = "group-id"
    values = [var.app-alb-sg-id]
  }
}

# # 아키텍팅할 때 임시로 사용할 sg 까먹지 말고 나중에 바꿔줘야함
# data "aws_security_group" "default-sg" {
#   filter {
#     name = "group-name"
#     values = ["default"]
#   }
# }

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}