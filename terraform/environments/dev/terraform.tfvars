aws_region    = "ap-south-1"
env_name      = "dev"
name_suffix   = "new"
vpc_cidr      = "172.31.0.0/16"
desired_nodes = 1
max_nodes     = 2

availability_zones = ["ap-south-1a", "ap-south-1b"]
private_subnet_cidrs = [
  "172.31.0.0/20",
  "172.31.16.0/20"
]

default_tags = {
  Owner = "devops"
  Env   = "dev"
}

# Control KMS and log group creation/override
create_kms_key             = true
existing_kms_key_arn       = null
create_cloudwatch_log_group = true
kms_key_alias              = "alias/eks/dev-eks-new"

# Enable pre-flight cleanup of conflicting KMS alias/log group
enable_conflict_cleanup = true
