data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc-name]
  }
}

data "aws_subnet" "subnet"{
    filter {
     name   = "tag:Name"
    values = [var.private-subnet1]
  }
}