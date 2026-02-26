
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}


variable "main_proxy_instance_ami_id" {
  type        = string
  description = "AMI ID for main-proxy instance server"
  default     = "ami-0eb615743219af12d"
}


variable "main_proxy_instance_type" {
  type        = string
  description = "Main-proxy instance type name"
  default     = "t3.micro"
}


variable "key_pair_name" {
  type        = string
  description = "SSH key for instance access"
  default     = "grant-admin-key"
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