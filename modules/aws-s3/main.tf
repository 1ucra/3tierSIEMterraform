resource "aws_s3_bucket" "image-bucket" {
  bucket = var.s3_name
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}