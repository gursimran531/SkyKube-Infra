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