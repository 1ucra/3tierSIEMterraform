resource "aws_s3_bucket" "image-bucket" {
  bucket = "hellowaws-image-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "artifact-bucket" {
  bucket = "hellowaws-artifact-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "logs-bucket" {
  bucket = "hellowaws-logs-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
