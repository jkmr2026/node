output "vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the created VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.this.cidr_block
  description = "CIDR block of the created VPC"
}
