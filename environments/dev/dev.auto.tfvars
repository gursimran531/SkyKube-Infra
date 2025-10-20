environment = "dev"
vpc_cidr    = "10.0.0.0/16"
public_subnets = {
  "us-east-1a" = "10.0.1.0/24"
  "us-east-1b" = "10.0.2.0/24"
}
app_subnets = {
  "us-east-1a" = "10.0.3.0/24"
  "us-east-1b" = "10.0.4.0/24"
}
cluster_name     = "SkyKube-cluster"
k8s_version      = "1.34"
instance_types   = ["t3.small"]
desired_capacity = 1
max_size         = 2
min_size         = 1
alb_dns_name     = "a769890b816054e349bc346ef4a55517-441138107.us-east-1.elb.amazonaws.com"
domain          = "singhops.net"
subdomain       = "dev"
