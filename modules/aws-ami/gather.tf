data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}

data "aws_subnet" "subnet"{
    filter {
     name   = "tag:Name"
    values = [var.db-subnet1]
  }
}

data "aws_security_group" "bastion-sg" {
  filter {
     name   = "tag:Name"
    values = ["example_sg"]
  }
}