data "aws_subnet" "db-subnet1"{
    filter {
     name   = "tag:Name"
    values = ["aws_subnet/db-subnet1"]
  }
}