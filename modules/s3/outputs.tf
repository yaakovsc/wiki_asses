output "bucket_name" {
  value = aws_s3_bucket.wiki.id
}

output "bucket_arn" {
  value = aws_s3_bucket.wiki.arn
}