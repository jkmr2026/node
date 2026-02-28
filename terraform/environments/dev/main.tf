provider "aws" {
  region = "ap-south-1"
}

module "dev_eks" {
  source       = "../../modules/eks_cluster"
  env_name     = "dev"
  vpc_id       = "vpc-04670c78280cef62c" # Your specific VPC
  desired_size = 1
  max_size     = 2
}
