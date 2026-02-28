variable "vpc_id" {
  type = string
}

variable "env_name" {
  type = string
}

variable "availability_zones" {
  description = "List of availability zones to create private subnets in"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets; must match availability_zones length"
  type        = list(string)
}

variable "tags" {
  description = "Additional tags applied to all resources"
  type        = map(string)
  default     = {}
}
