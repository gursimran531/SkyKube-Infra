variable "alb_dns_name" {
  description = "The DNS name of the ALB to point the record to"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "domain" {
  description = "The primary domain name"
  type        = string
  default     = "singhops.net"
}

variable "subdomain" {
  description = "The subdomain for the DNS record (e.g., dev)"
  type        = string
  default     = "dev"
}