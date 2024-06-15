data "aws_vpc" "hellowaws-vpc" {
  filter {
    name   = "tag:Name"
    values = ["aws_vpc/hellowaws-vpc"]
  }
}


data "aws_ec2_managed_prefix_list" "cloudfront" {
  filter {
    name   = "prefix-list-name"
    values = ["com.amazonaws.global.cloudfront.origin-facing"] # com.amazonaws.global.cloudfront.origin-facing
  }
}
