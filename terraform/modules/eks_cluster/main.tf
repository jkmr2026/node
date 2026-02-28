# Fetch existing VPC
data "aws_vpc" "this" {
  id = var.vpc_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.env_name}-eks"
  cluster_version = "1.31"

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = var.private_subnet_ids

  # Mandatory for small instances
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    minimal = {
      instance_types = ["t2.micro"]
      min_size     = 1
      max_size     = var.max_nodes
      desired_size = var.desired_nodes
    }
  }
}
