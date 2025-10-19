output "eks-cluster-role" {
  description = "The IAM Role ARN for the EKS Cluster"
  value       = aws_iam_role.EKSrole.arn
}

output "eks-node-group-role" {
  description = "The IAM Role ARN for the EKS Node Group"
  value       = aws_iam_role.eks_node_group_role.arn
}
