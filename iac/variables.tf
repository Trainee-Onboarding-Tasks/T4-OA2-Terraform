
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}


variable "proxy_server_instance_ami_id" {
  type        = string
  description = "AMI ID for proxy instance server"
  default     = "ami-0bff6c92510b45277"
}


variable "ansible_server_instance_ami_id" {
  type        = string
  description = "AMI ID for proxy instance server"
  default     = "ami-0dd23b7cbc421d704"
}


variable "proxy_server_instance_type" {
  type        = string
  description = "Proxy server instance type name"
  default     = "t3.micro"
}


variable "ansible_server_instance_type" {
  type        = string
  description = "Proxy server instance type name"
  default     = "t3.micro"
}


variable "alb_listener_http_port" {
  type        = number
  description = "ALB HTTP listener port"
  default     = 80
}


variable "alb_listener_https_port" {
  type        = number
  description = "ALB HTTPS listener port"
  default     = 443
}


variable "proxy_listener_port" {
  type        = number
  description = "Proxy server listener port"
  default     = 80
}


variable "https_certificate_arn" {
  type        = string
  description = "HTTPS certificate arn"
  default     = "arn:aws:acm:us-east-1:971778147356:certificate/90ce286a-fa70-4054-99f7-a201c1aed4b2"
}
