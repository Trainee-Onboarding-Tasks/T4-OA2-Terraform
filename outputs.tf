
output "proxy_server_public_ip" {
  description = "Public IP address of proxy server"
  value = module.servers.proxy_server_public_ip
}


output "ansible_server_public_ip" {
  description = "Public IP address of ansible server"
  value = module.servers.ansible_server_public_ip
}


output "alb_dns_name" {
  description = "ALB access DNS name"
  value       = "http://${module.alb.alb_dns_name}"
}


output "dns_name" {
  description = "NDS URL name"
  value       = "https://trainee-keycloack.store"
}
