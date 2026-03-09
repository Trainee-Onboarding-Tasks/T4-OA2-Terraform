
output "monitoring_public_ip" {
  description = "Monitoring server public IP-address"
  value       = module.servers.monitoring_server_public_ip
}
