
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main_vpc.id
}


output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}


output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = [for subnet in aws_subnet.public_subnets : subnet.cidr_block]
}
