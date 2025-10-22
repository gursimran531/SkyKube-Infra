variable "tags" {
  description = "A map of tags to assign to the S3 bucket."
  type        = map(string)
  default     = {}
}

variable "frontend_url" {
  description = "The URL of the frontend application allowed to access the S3 bucket."
  type        = string
}