
data "aws_subnet" "private-subnet1" {
  filter {
    name   = "tag:Name"
    values = ["aws_subnet/private-subnet1"]
  }
}

data "aws_subnet" "private-subnet2" {
  filter {
    name   = "tag:Name"
    values = ["aws_subnet/private-subnet2"]
  }
}
