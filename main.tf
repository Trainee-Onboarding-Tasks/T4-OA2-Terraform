
terraform {
  required_version = ">=1.5.0"

  backend "s3" {
    bucket   = "wordpress-app-ss-state-bucket"
    key      = "app/state"
    region   = "us-east-1"
    encrypt  = true
  }
}


provider "aws" {
  region = var.aws_region
}


module "vpc" {
  source = "./modules/vpc"

  cidr   = "10.0.0.0/24"

  available_zones_list = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnets = [
    "10.0.0.0/27",
    "10.0.0.32/27"
  ]
}


module "sg" {
  source          = "./modules/sg"
  main_vpc_id     = module.vpc.vpc_id

  security_groups = {

    alb_sg = {
      ingress_ports_tcp       = [80, 443, 8080, 81]
      ingress_ports_udp       = []
      allowed_cidr_blocks     = ["0.0.0.0/0"]
      allowed_security_groups = []
    }

    proxy_server_sg = {
      ingress_ports_tcp       = [22, 80, 443, 8080, 81]
      ingress_ports_udp       = []
      allowed_cidr_blocks     = ["0.0.0.0/0"]
      allowed_security_groups = ["alb_sg"]
    }

    ansible_server_sg = {
      ingress_ports_tcp       = [22, 80, 443]
      ingress_ports_udp       = []
      allowed_cidr_blocks     = ["0.0.0.0/0"]
      allowed_security_groups = []
    }

  }
}


module "servers" {
  source                            = "./modules/servers"

  proxy_server_instance_ami_id      = var.proxy_server_instance_ami_id
  ansible_server_instance_ami_id    = var.ansible_server_instance_ami_id

  proxy_server_instance_type        = var.proxy_server_instance_type
  ansible_server_instance_type      = var.ansible_server_instance_type

  list_of_proxy_server_sg_ids       = [module.sg.security_group_ids["proxy_server_sg"]]
  list_of_ansible_server_sg_ids     = [module.sg.security_group_ids["ansible_server_sg"]]

  public_subnet_ids                 = module.vpc.public_subnet_ids

  key_pair_name                     = var.key_pair_name
}


module "alb" {
  source                   = "./modules/alb"

  vpc_id                   = module.vpc.vpc_id
  public_subnet_ids        = module.vpc.public_subnet_ids
  alb_sg_id                = [module.sg.security_group_ids["alb_sg"]]
  proxy_server_instance_id = module.servers.proxy_server_instance_id
}
