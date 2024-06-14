output "artifact-bucket-id" {
  value = aws_s3_bucket.artifact-bucket.id
}

output "logs-bucket-id" {
  value = aws_s3_bucket.logs-bucket.id
}