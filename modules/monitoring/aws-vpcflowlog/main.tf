# Create IAM policy for VPC Flow Logs
resource "aws_iam_policy" "vpcflowlog-policy" {
  name        = "vpcFlowLogPolicy2"
  description = "IAM policy for VPC Flow Logs"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Resource": "*"
      }
    ]
  })

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_iam_policy/vpcflowlog-policy2"
    owner = "ktd-admin"
  }
}

# Create IAM role for VPC Flow Logs
resource "aws_iam_role" "vpcflowlog-role" {
  name               = "vpcFlowLogRole2"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "vpc-flow-logs.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_iam_policy/vpcflowlog-role2"
    owner = "ktd-admin"
  }
}

resource "aws_flow_log" "hellowawsVPC-flowlog" {
  log_destination      = data.aws_cloudwatch_log_group.hellowawsVPC-flowlog.arn
  iam_role_arn         = aws_iam_role.vpcflowlog-role.arn
  vpc_id               = data.aws_vpc.hellowaws-vpc.id
  traffic_type         = "REJECT"
  log_destination_type = "cloud-watch-logs"
  max_aggregation_interval = 60

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_flow_log/hellowawsVPC-flowlog"
    owner = "ktd-admin"
  }
}

