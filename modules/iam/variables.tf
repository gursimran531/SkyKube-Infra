variable "environment" {
  description = "The environment for the resources (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "For dynamic tagging"
  type        = map(string)
  default     = {}
}

variable "voice_notes_bucket_arn" {
  description = "The ARN of the SkyKube Voice Notes S3 bucket."
  type        = string
}
