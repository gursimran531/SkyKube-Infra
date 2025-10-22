variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "skykube-cluster"
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS cluster."
  type        = string
}

variable "k8s_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.28"
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the EKS node group."
  type        = list(string)
}

variable "node_role_arn" {
  description = "The ARN of the IAM role that provides permissions for the EKS node group."
  type        = string
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

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "The AWS region to deploy the EKS cluster."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed."
  type        = string
}

variable "eks_role" {
  description = "The EKS role to depend on."
  type        = any
}