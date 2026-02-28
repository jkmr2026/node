provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source   = "../../modules/vpc"
  env_name = var.env_name
  vpc_cidr = var.vpc_cidr
  tags     = var.default_tags
}

module "eks_deploy" {
  source        = "../../modules/eks_cluster"
  vpc_id             = module.vpc.vpc_id
  env_name           = var.env_name
  desired_nodes      = var.desired_nodes
  max_nodes          = var.max_nodes
  private_subnet_ids = module.private_subnets.private_subnet_ids
}

module "private_subnets" {
  source = "../../modules/subnets"

  vpc_id               = module.vpc.vpc_id
  env_name             = var.env_name
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.default_tags
}

# Define these locally so they can be fed into the module
variable "aws_region"        {}
variable "vpc_cidr"          {}
variable "env_name"          {}
variable "desired_nodes"     {}
variable "max_nodes"         {}
variable "availability_zones"   {}
variable "private_subnet_cidrs" {}
variable "default_tags"         { default = {} }
