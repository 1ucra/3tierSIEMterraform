resource "aws_s3_bucket" "artifact-bucket" {
  bucket = var.s3_artifact_bucket_name
  force_destroy = true
  
  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_s3_bucket/artifact-bucket"
    owner = "ktd-admin"
  }
}

resource "aws_s3_bucket_public_access_block" "artifact-bucket-pab" {
  bucket = aws_s3_bucket.artifact-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs-bucket" {
  bucket = var.s3_logs_bucket_name

  tags = {
    createDate = "${formatdate("YYYYMMDD", timestamp())}"
    Name = "aws_s3_bucket/logs-bucket"
    owner = "ktd-admin"
  }
}

resource "aws_s3_bucket_public_access_block" "logs-bucket-pab" {
  bucket = aws_s3_bucket.logs-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}