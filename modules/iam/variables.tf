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