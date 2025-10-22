resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "voice_notes" {
  bucket = "skykube-voice-notes-${random_id.bucket_id.hex}"
  force_destroy = true

  tags = merge(
    {
      Name = "SkyKube Voice Notes Bucket"
    },
    var.tags
  )
}

resource "aws_s3_bucket_lifecycle_configuration" "voice_notes_lifecycle" {
  bucket = aws_s3_bucket.voice_notes.id

  rule {
    id     = "ExpireVoiceNotes-1day"
    status = "Enabled"

    expiration {
      days = 1
    }
  } 
}

resource "aws_s3_bucket_cors_configuration" "voice_bucket_cors" {

  bucket = aws_s3_bucket.voice_notes.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["${var.frontend_url}"] 
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "GET"]
    allowed_origins = ["http://localhost:*", "http://127.0.0.1:*"]
    max_age_seconds = 3000
  }
}