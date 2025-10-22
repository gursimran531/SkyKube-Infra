provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  environment    = var.environment
  tags           = local.common_tags
  app_subnets    = var.app_subnets
}

module "iam" {
  source                 = "../../modules/iam"
  voice_notes_bucket_arn = module.s3.voice_notes_bucket_arn
  environment            = var.environment
  tags                   = local.common_tags
}

module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment
  tags        = local.common_tags
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  cluster_role_arn   = module.iam.eks-cluster-role
  k8s_version        = var.k8s_version
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.app_subnet_ids
  node_role_arn      = module.iam.eks-node-group-role
  instance_types     = var.instance_types
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  tags               = local.common_tags
  vpc_id             = module.vpc.vpc_id
  aws_region         = var.region
  eks_role           = module.iam.eks-cluster-role

}

module "dns" {
  source       = "../../modules/dns"
  tags         = local.common_tags
  alb_dns_name = var.alb_dns_name
  domain       = var.domain
  subdomain    = var.subdomain


}

module "s3" {
  source = "../../modules/s3"
  frontend_url = var.frontend_url
  tags = local.common_tags
}

module "lambda" {
  source                  = "../../modules/lambda"
  voice_notes_bucket_name = module.s3.voice_notes_bucket_name
  lambda_role_arn         = module.iam.lambda_role_arn
  depends_on              = [module.s3, module.eks, module.iam]
}