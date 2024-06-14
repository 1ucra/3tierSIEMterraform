data "aws_vpc" "hellowaws-vpc" {
  filter {
    name   = "tag:Name"
    values = ["aws_vpc/hellowaws-vpc"]
  }
}

data "aws_cloudwatch_log_group" "hellowawsVPC-flowlog" {
  name = "hellowawsVPC-flowlog"
}
