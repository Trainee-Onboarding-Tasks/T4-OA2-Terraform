
variable "vpc_id" {
  type        = string
  description = "ID of main vpc"
}


variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet ids for ALB"
}


variable "alb_sg_id" {
  type        = list(string)
  description = "Security group ID for ALB server"
}


variable "proxy_server_instance_id" {
  type        = string
  description = "Proxy server instance ID for target group"
}


# variable "alb_http_port" {
#   type        = number
#   description = "ALB HTTP port"
# }


# variable "llm_access_port" {
#   type        = number
#   description = "LLM server access port"
# }