
variable "proxy_server_instance_ami_id" {
  type        = string
  description = "AMI ID for proxy instance server"
}


variable "proxy_server_instance_type" {
  type        = string
  description = "Proxy server instance type name"
}


variable "list_of_proxy_server_sg_ids" {
  type        = list(string)
  description = "Security group ID for proxy server"
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids for proxy and ansible servers"
}


variable "iam_proxy_profile_name" {
  type        = string
  description = "IAM instance profile name for Proxy server"
}