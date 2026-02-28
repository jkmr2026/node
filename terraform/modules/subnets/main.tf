locals {
  # zipmap enforces equal lengths between AZs and CIDR blocks
  private_subnets = zipmap(var.availability_zones, var.private_subnet_cidrs)
}

resource "aws_subnet" "private" {
  for_each = local.private_subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = false

  tags = merge({
    Name                              = "${var.env_name}-private-${each.key}"
    "kubernetes.io/role/internal-elb" = "1"
  }, var.tags)
}
