
resource "aws_instance" "proxy_server" {
  ami                         = var.proxy_server_instance_ami_id
  instance_type               = var.proxy_server_instance_type
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = var.list_of_proxy_server_sg_ids
  iam_instance_profile        = var.iam_proxy_profile_name

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
