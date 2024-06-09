resource "aws_s3_bucket" "image-bucket" {
  bucket = var.s3_image_bucket_name

  tags = {
    Name        = "My bucket1"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "artifact-bucket" {
  bucket = var.s3_artifact_bucket_name
  force_destroy = true
  
  tags = {
    Name        = "My bucket2"
    Environment = "Dev"
  }


}

resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.artifact-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "logs-bucket" {
  bucket = var.s3_logs_bucket_name

  tags = {
    Name        = "My bucket3"
    Environment = "Dev"
  }
}
