aws_region    = "ap-south-1"
vpc_id        = "vpc-04670c78280cef62c"
env_name      = "dev"
desired_nodes = 1
max_nodes     = 2

availability_zones = ["ap-south-1a", "ap-south-1b"]
private_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

default_tags = {
  Owner = "devops"
  Env   = "dev"
}
