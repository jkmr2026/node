output "private_subnet_ids" {
  description = "IDs of created private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

output "private_subnet_arns" {
  description = "ARNs of created private subnets"
  value       = [for s in aws_subnet.private : s.arn]
}
