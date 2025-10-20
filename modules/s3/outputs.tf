
output "voice_notes_bucket_name" {
  description = "The name of the SkyKube Voice Notes S3 bucket."
  value       = aws_s3_bucket.voice_notes.bucket
}

output "voice_notes_bucket_arn" {
  description = "The ARN of the SkyKube Voice Notes S3 bucket."
  value       = aws_s3_bucket.voice_notes.arn
}