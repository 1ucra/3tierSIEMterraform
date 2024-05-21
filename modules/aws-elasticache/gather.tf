data "aws_subnet" "db_subnet1"{
    filter {
    name   = "tag:Name"
    values = [var.DB_SUBNET1]
  }
}

data "aws_subnet" "db_subnet2"{
    filter {
    name   = "tag:Name"
    values = [var.DB_SUBNET2]
  }
}

data "aws_security_group" "redis-sg" {
  filter {
    name   = "tag:Name"
    values = [var.REDIS_SG_NAME]
  }
}
