# Fetch existing VPC
data "aws_vpc" "this" {
  id = var.vpc_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name != "" ? var.cluster_name : "${var.env_name}-eks"
  cluster_version = "1.31"

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = var.private_subnet_ids

  # Mandatory for small instances
  cluster_endpoint_public_access = true

  # KMS handling: use alias override when creating, or supply existing key ARN
  create_kms_key          = var.create_kms_key
  kms_key_arn             = var.create_kms_key ? null : var.existing_kms_key_arn
  kms_key_deletion_window = 7
  kms_key_aliases         = var.create_kms_key && var.kms_key_alias != "" ? [var.kms_key_alias] : []
  enable_kms_key_rotation = var.create_kms_key

  # CloudWatch log group: only created when flag is true
  create_cloudwatch_log_group = var.create_cloudwatch_log_group

  eks_managed_node_groups = {
    minimal = {
      instance_types = ["t2.micro"]
      min_size     = 1
      max_size     = var.max_nodes
      desired_size = var.desired_nodes
    }
  }
}
