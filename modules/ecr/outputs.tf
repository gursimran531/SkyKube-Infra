output "repo_url" {
  description = "The ECR Repository URL for SkyKube Application"
  value       = aws_ecr_repository.skykube_app.repository_url
}