
variable "main_proxy_server_instance_ami_id" {
  type        = string
  description = "AMI ID for main-proxy instance server"
}


variable "main_proxy_server_instance_type" {
  type        = string
  description = "Main-proxy-server instance type name"
}


variable "main_proxy_server_sg_id" {
  type        = string
  description = "Security group ID for main-proxy-server"
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids for main-proxy-servers"
}


variable "key_pair_name" {
  type        = string
  description = "SSH key for instance access"
}


variable "github_client_id" {
  type        = string
  description = ""
}


variable "github_client_secret" {
  type        = string
  description = ""
}


variable "cookie_secret" {
  type        = string
  description = ""
}