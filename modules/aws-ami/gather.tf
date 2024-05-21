data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "subnet"{
    filter {
     name   = "tag:Name"
    values = [var.DB_SUBNET1]
  }
}

data "aws_security_group" "bastion-sg" {
  filter {
     name   = "tag:Name"
     values = ["bastion_sg"]
  }
}