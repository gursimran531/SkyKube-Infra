variable "voice_notes_bucket_name" {
    description = "The name of the SkyKube Voice Notes S3 bucket."
    type        = string
}

variable "lambda_role_arn" {
    description = "The ARN of the IAM role for the Lambda function."
    type        = string
}