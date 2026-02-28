aws_region    = "ap-south-1"
env_name      = "dev"
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
