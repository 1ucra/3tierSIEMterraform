resource "aws_sns_topic" "system-alert" {
  name = "system-alert${formatdate("YYYYMMDD", timestamp())}"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_sns_topic/system-alert"
    owner = "ktd-admin"
  }
}

resource "aws_sns_topic_subscription" "email_subscription1" {
  topic_arn = aws_sns_topic.system-alert.arn
  protocol  = "email"
  endpoint  = "kwanay1010@naver.com"
}

resource "aws_sns_topic" "secure-alert" {
  name = "secure-alert${formatdate("YYYYMMDD", timestamp())}"

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_sns_topic/secure-alert"
    owner = "ktd-admin"
  }
}

resource "aws_sns_topic_subscription" "email_subscription2" {
  topic_arn = aws_sns_topic.secure-alert.arn
  protocol  = "email"
  endpoint  = "kwanay1010@naver.com"
}