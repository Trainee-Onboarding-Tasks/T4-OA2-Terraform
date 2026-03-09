
output "alb_dns_name" {
  description = "ALB access DNS name"
  value       = aws_lb.proxy_alb.dns_name
}
