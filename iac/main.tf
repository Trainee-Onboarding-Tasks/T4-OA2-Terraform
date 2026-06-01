
terraform {
  required_version = ">=1.5.0"

  backend "s3" {
    bucket   = "trainee-onboarding-tasks"
    key      = "t4/state"
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
  }
}


module "iam" {
  source = "./modules/iam"
}


module "servers" {
  source                            = "./modules/servers"

  proxy_server_instance_ami_id      = var.proxy_server_instance_ami_id
  proxy_server_instance_type        = var.proxy_server_instance_type

  list_of_proxy_server_sg_ids       = [module.sg.security_group_ids["proxy_server_sg"]]
  public_subnet_ids                 = module.vpc.public_subnet_ids

  iam_proxy_profile_name            = module.iam.iam_proxy_profile_name
}


module "alb" {
  source                    = "./modules/alb"

  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids
  alb_sg_ids                = [module.sg.security_group_ids["alb_sg"]]
  
  proxy_server_instance_id  = module.servers.proxy_server_instance_id

  alb_listener_http_port    = var.alb_listener_http_port
  alb_listener_https_port   = var.alb_listener_https_port
  proxy_listener_port       = var.proxy_listener_port
  https_certificate_arn     = var.https_certificate_arn
}
