
resource "aws_instance" "proxy_server" {
  ami                         = var.proxy_server_instance_ami_id
  instance_type               = var.proxy_server_instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = var.list_of_proxy_server_sg_ids
  key_name                    = var.key_pair_name

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Proxy-server"
  }
}


resource "aws_instance" "ansible_server" {
  ami                         = var.ansible_server_instance_ami_id
  instance_type               = var.ansible_server_instance_type
  subnet_id                   = var.public_subnet_ids[1]
  vpc_security_group_ids      = var.list_of_ansible_server_sg_ids
  key_name                    = var.key_pair_name

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Ansible-server"
  }
}
