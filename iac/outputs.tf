
output "proxy_server_public_ip" {
  description = "Public IP address of proxy server"
  value = module.servers.proxy_server_public_ip
}


output "proxy_server_instance_id" {
  value       =  module.servers.proxy_server_instance_id
  description = "Proxy server instance ID"
}


output "alb_dns_name" {
  description = "ALB access DNS name"
  value       = "http://${module.alb.alb_dns_name}"
}


output "dns_name" {
  description = "DNS URL name"
  value       = "https://trainee-keycloack.store"
}
