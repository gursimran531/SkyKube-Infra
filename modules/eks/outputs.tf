output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.skykube.name
}
output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.skykube.endpoint
}
