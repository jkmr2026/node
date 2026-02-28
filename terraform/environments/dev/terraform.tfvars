aws_region    = "ap-south-1"
vpc_id        = "vpc-04670c78280cef62c"
env_name      = "dev"
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
