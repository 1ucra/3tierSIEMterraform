resource "aws_s3_bucket" "S3-For-SourceCode" {
  bucket = var.s3-name
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}