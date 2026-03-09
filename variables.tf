
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}


variable "proxy_server_instance_ami_id" {
  type        = string
  description = "AMI ID for proxy instance server"
  default     = "ami-085191ce42d057e42"
}


variable "ansible_server_instance_ami_id" {
  type        = string
  description = "AMI ID for ansible instance server"
  default     = "ami-0bb30b8e72c272505"
}


variable "proxy_server_instance_type" {
  type        = string
  description = "Proxy server instance type name"
  default     = "t3.medium"
}


variable "ansible_server_instance_type" {
  type        = string
  description = "Ansible server instance type name"
  default     = "t3.micro"
}


variable "key_pair_name" {
  type        = string
  description = "SSH key for instance access"
  default     = "grant-admin-key"
}
