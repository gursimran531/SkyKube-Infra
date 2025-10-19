resource "aws_ecr_repository" "skykube_app" {
  name                 = "skykube-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
  tags = merge(
    {
      Name = "SkyKube-ECR-${var.environment}"
    },
    var.tags
  )
}