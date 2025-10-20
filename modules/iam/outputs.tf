output "eks-cluster-role" {
  description = "The IAM Role ARN for the EKS Cluster"
  value       = aws_iam_role.EKSrole.arn
}

output "eks-node-group-role" {
  description = "The IAM Role ARN for the EKS Node Group"
  value       = aws_iam_role.eks_node_group_role.arn
}

output "lambda_role_arn" {
  description = "The ARN of the IAM role for the Lambda function."
  value       = aws_iam_role.lambda_role.arn
}