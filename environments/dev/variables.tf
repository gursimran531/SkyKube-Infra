variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "skykube-cluster"
}

variable "k8s_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.28"
}

variable "instance_types" {
  description = "A list of instance types for the EKS node group."
  type        = list(string)
  default     = ["t3.small"] # Using small for learning/testing purposes (broke)
}

variable "desired_capacity" {
  description = "The desired number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum number of worker nodes in the EKS node group."
  type        = number
  default     = 2
}

variable "min_size" {
  description = "The minimum number of worker nodes in the EKS node group."
  type        = number
  default     = 1
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Specify a valid CIDR block for VPC"
  }
}

variable "public_subnets" {
  description = "Specify az and cidr block for each public subnet"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

variable "app_subnets" {
  description = "Specify az and cidr block for each private subnet for app tier"
  type        = map(string)
  default = {
    "us-east-1a" = "10.0.3.0/24"
    "us-east-1b" = "10.0.4.0/24"
  }
}

variable "alb_dns_name" {
  description = "The DNS name of the ALB to point the record to"
  type        = string
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

variable "frontend_url" {
  description = "The URL for the frontend application"
  type        = string
  default     = "http://dev.singhops.net"
}