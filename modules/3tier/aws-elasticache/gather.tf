data "aws_subnet" "db_subnet1"{
    filter {
    name   = "tag:Name"
    values = [var.db_subnet1]
  }
}

data "aws_subnet" "db_subnet2"{
    filter {
    name   = "tag:Name"
    values = [var.db_subnet2]
  }
}

