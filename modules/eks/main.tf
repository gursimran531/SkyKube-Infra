resource "aws_eks_cluster" "skykube" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids              = concat(var.public_subnet_ids, var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

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