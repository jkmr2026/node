provider "aws" {
  region = var.aws_region
}

module "eks_deploy" {
  source        = "../../modules/eks_cluster"
  vpc_id        = var.vpc_id
  env_name      = var.env_name
  desired_nodes = var.desired_nodes
  max_nodes     = var.max_nodes
}

# Define these locally so they can be fed into the module
variable "aws_region"    {}
variable "vpc_id"        {}
variable "env_name"      {}
variable "desired_nodes" {}
variable "max_nodes"     {}
