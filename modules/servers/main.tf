
resource "aws_instance" "main_proxy_server" {
  ami                         = var.main_proxy_server_instance_ami_id
  instance_type               = var.main_proxy_server_instance_type
  subnet_id                   = var.public_subnet_ids[1]
  vpc_security_group_ids      = [var.main_proxy_server_sg_id]
  key_name                    = var.key_pair_name

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 7
    volume_type           = "gp3"
    delete_on_termination = true
  }


  user_data = templatefile("${path.module}/../../scripts/install_oauth_nginx.sh.tpl", {
    GITHUB_CLIENT_ID     = var.github_client_id
    GITHUB_CLIENT_SECRET = var.github_client_secret
    COOKIE_SECRET        = var.cookie_secret
  })

  tags = {
    Name = "Main-server"
  }
}
