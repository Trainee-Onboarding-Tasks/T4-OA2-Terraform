
variable "vpc_id" {
  type        = string
  description = "Main VPC ID"
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids for ALB"
} 


variable "alb_sg_ids" {
  type        = list(string)
  description = "List of security group IDs for ALB"
}


variable "alb_listener_http_port" {
  type        = number
  description = "ALB HTTP listener port"
}


variable "alb_listener_https_port" {
  type        = number
  description = "ALB HTTPS listener port"
}


variable "proxy_listener_port" {
  type        = number
  description = "Proxy listener port"
}


variable "proxy_server_instance_id" {
  type        = string
  description = "Proxy server instance ID for target group"
}


variable "https_certificate_arn" {
  type        = string
  description = "HTTPS certificate arn"
}
