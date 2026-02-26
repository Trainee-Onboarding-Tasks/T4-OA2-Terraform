
output "main_proxy_server_public_ip" {
  description = "Main-proxy-server server public IP-address"
  value       = aws_instance.main_proxy_server.public_ip
}
