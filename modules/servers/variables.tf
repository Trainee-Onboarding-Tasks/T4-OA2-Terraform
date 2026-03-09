
variable "proxy_server_instance_ami_id" {
  type        = string
  description = "AMI ID for proxy instance server"
}


variable "ansible_server_instance_ami_id" {
  type        = string
  description = "AMI ID for ansible instance server"
}


variable "proxy_server_instance_type" {
  type        = string
  description = "Proxy server instance type name"
}


variable "ansible_server_instance_type" {
  type        = string
  description = "Ansible server instance type name"
}


variable "list_of_proxy_server_sg_ids" {
  type        = list(string)
  description = "Security group ID for proxy server"
}


variable "list_of_ansible_server_sg_ids" {
  type        = list(string)
  description = "Security group ID for ansible server"
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids for proxy and ansible servers"
}


variable "key_pair_name" {
  type        = string
  description = "SSH key for instance access"
}
