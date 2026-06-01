
variable "cidr" {
  type        = string
  description = "CIDR block for the VPC"
}


variable "available_zones_list" {
  type        = list(string)
  description = "List of availability zones to distribute subnets across"
}


variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}
