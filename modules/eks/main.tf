resource "aws_eks_cluster" "skykube" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  depends_on = [var.eks_role]

 # enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = merge(
    {
      Name = "${var.cluster_name}"
    },
    var.tags
  )
}

resource "aws_eks_node_group" "skykube_nodes" {
  cluster_name    = aws_eks_cluster.skykube.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.instance_types
  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  tags = merge(
    {
      Name = "${var.cluster_name}-nodegroup"
    },
    var.tags
  )
}

# Installing AWS Load Balancer Controller via Helm ( Keeping IAM here for simplicity)

# Define the IAM OIDC Provider resource using the EKS cluster's issuer URL
resource "aws_iam_openid_connect_provider" "skykube_oidc_provider" {
  url = aws_eks_cluster.skykube.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"] 
  depends_on = [aws_eks_cluster.skykube] 
}

#  Create IAM policy and role for the ALB Controller
resource "aws_iam_policy" "alb_controller" {
  name        = "ALBControllerPolicy-${aws_eks_cluster.skykube.name}"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/iam_policy.json")  # Path to the ALB Controller policy document
}

locals {
  sa_namespace = "kube-system"
  sa_name      = "aws-load-balancer-controller"
  oidc_hostname     = replace(aws_eks_cluster.skykube.identity[0].oidc[0].issuer, "https://", "")
}

data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.skykube_oidc_provider.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_hostname}:sub"
      values   = ["system:serviceaccount:${local.sa_namespace}:${local.sa_name}"]
    }
  }
}

resource "aws_iam_role" "alb_controller" {
  name               = "eks-alb-controller-${aws_eks_cluster.skykube.name}"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json

  depends_on = [aws_eks_cluster.skykube]
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

# Kubernetes provider (local to module)
data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.skykube.name
}
provider "kubernetes" {
  alias                  = "eks"
  host                   = aws_eks_cluster.skykube.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.skykube.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Create ServiceAccount annotated with IRSA role (Commented out as Helm chart will create it)
# resource "kubernetes_service_account" "alb_sa" {
#   metadata {
#     name      = local.sa_name
#     namespace = local.sa_namespace
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.alb_controller.arn
#     }
#   }
# }

# Security Group for ALB (required)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for ALB ingress controller"
  vpc_id      = var.vpc_id

  # Allow inbound HTTP and HTTPS traffic from the internet
  ingress {
    description      = "Allow HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Allow all outbound (default for ALB)
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}


# Helm install AWS Load Balancer Controller
provider "helm" {
  alias       = "eks"
  kubernetes = {
  host                   = aws_eks_cluster.skykube.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.skykube.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
  }
}

resource "helm_release" "alb_controller" {
  name             = "aws-load-balancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = local.sa_namespace
  create_namespace = false
  
  provider = helm.eks 

  values = [
    <<YAML
clusterName: "${aws_eks_cluster.skykube.name}"
serviceAccount:
  create: true 
  name: "${local.sa_name}"
  annotations:
    # Set the IRSA annotation directly on the chart-managed SA
    eks.amazonaws.com/role-arn: "${aws_iam_role.alb_controller.arn}"
region: "${var.aws_region}"
vpcId: "${var.vpc_id}" 
securityGroup: "${aws_security_group.alb_sg.id}"
YAML
  ]
}