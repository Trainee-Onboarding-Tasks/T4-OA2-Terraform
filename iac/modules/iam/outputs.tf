
output "iam_proxy_profile_name" {
  description = "IAM instance profile name used by Proxy server"
  value       = aws_iam_instance_profile.proxy_profile.name
}
