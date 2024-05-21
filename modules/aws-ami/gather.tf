data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet" "subnet"{
    filter {
     name   = "tag:Name"
    values = [var.db_subnet1]
  }
}