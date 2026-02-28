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

  # Optional overrides to avoid name collisions
  cluster_name               = "${var.env_name}-eks-${var.name_suffix}"
  create_kms_key             = var.create_kms_key
  existing_kms_key_arn       = var.existing_kms_key_arn
  create_cloudwatch_log_group = var.create_cloudwatch_log_group
  cloudwatch_log_group_name   = var.cloudwatch_log_group_name
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
variable "name_suffix"       { default = "new" }
variable "desired_nodes"     {}
variable "max_nodes"         {}
variable "availability_zones"   {}
variable "private_subnet_cidrs" {}
variable "default_tags"         { default = {} }
variable "create_kms_key"          { default = true }
variable "existing_kms_key_arn"    { default = null }
variable "create_cloudwatch_log_group" { default = true }
variable "cloudwatch_log_group_name"   { default = "" }
