resource "aws_cloudwatch_log_group" "nginx-access" {
  name              = "nginx/access"
  retention_in_days = 1
  kms_key_id        = null  # 표준 로그 클래스는 기본 KMS 키를 사용하므로 null로 설정

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_cloudwatch_log_group/nginx-access"
    owner = "ktd-admin"
  }
}

resource "aws_cloudwatch_log_group" "nginx-error" {
  name              = "nginx/error"
  retention_in_days = 1
  kms_key_id        = null  # 표준 로그 클래스는 기본 KMS 키를 사용하므로 null로 설정

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_cloudwatch_log_group/nginx-error"
    owner = "ktd-admin"
  }
}

resource "aws_cloudwatch_log_group" "hellowawsVPC-flowlog" {
  name              = "hellowawsVPC-flowlog"
  retention_in_days = 1
  kms_key_id        = null  # 표준 로그 클래스는 기본 KMS 키를 사용하므로 null로 설정

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_cloudwatch_log_group/hellowawsVPC-flowlog"
    owner = "ktd-admin"
  }
}