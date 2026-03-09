
output "vpc_id" {
    description = "Main VPC ID"
    value       = aws_vpc.main_vpc.id
}


output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public_subnets : subnet.id]
}


output "public_subnet_cidrs" {
  description = "List of public subnet address"
  value       = [for subnet in aws_subnet.public_subnets : subnet.cidr_block]
}
