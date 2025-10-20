output "Skykube-ECR-Repo" {
  description = "The ECR Repository URL for SkyKube Application"
  value       = module.ecr.repo_url
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}
output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "app_subnet_ids" {
  description = "The IDs of the application subnets"
  value       = module.vpc.app_subnet_ids
}


output "api_gateway_endpoint" {
  description = "The endpoint URL of the API Gateway for the voice note service."
  value       = module.lambda.api_gateway_endpoint
}