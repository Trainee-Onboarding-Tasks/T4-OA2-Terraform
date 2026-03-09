
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

  cidr = "10.0.0.0/24"

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
  source      = "./modules/sg"
  main_vpc_id = module.vpc.vpc_id

  security_groups = {

    main_proxy_server_sg = {
      ingress_ports_tcp       = [22, 80, 443]
      ingress_ports_udp       = []
      allowed_cidr_blocks     = ["0.0.0.0/0"]
      allowed_security_groups = []
    }
  }
}


module "servers" {
  source                      = "./modules/servers"

  main_proxy_server_instance_ami_id  = var.main_proxy_instance_ami_id
  main_proxy_server_instance_type    = var.main_proxy_instance_type
  main_proxy_server_sg_id            = module.sg.security_group_ids["main_proxy_server_sg"] 
  public_subnet_ids                  = module.vpc.public_subnet_ids         

  key_pair_name                      = var.key_pair_name

  github_client_id                   = var.github_client_id
  github_client_secret               = var.github_client_secret
  cookie_secret                      = var.cookie_secret
}
