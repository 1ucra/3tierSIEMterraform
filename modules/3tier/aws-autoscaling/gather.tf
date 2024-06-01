
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
