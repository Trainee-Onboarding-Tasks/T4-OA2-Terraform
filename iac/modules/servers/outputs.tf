
output "proxy_server_public_ip" {
  description = "Public IP address of proxy server"
  value       = aws_instance.proxy_server.public_ip
}


output "proxy_server_instance_id" {
  value       = aws_instance.proxy_server.id
  description = "Proxy server instance ID"
}
