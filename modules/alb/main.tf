
resource "aws_lb" "proxy_alb" {
  name               = "proxy-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_id
  subnets            = var.public_subnet_ids

  tags = {
    Name = "Proxy-ALB"
  }
}


resource "aws_lb_target_group" "proxy_tg" {
  name     = "proxy-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "80"
  }
}


resource "aws_lb_target_group_attachment" "proxy_attach" {
  target_group_arn = aws_lb_target_group.proxy_tg.arn
  target_id        = var.proxy_server_instance_id
  port             = 80
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.proxy_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn   = "arn:aws:acm:us-east-1:971778147356:certificate/90ce286a-fa70-4054-99f7-a201c1aed4b2"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy_tg.arn
  }
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.proxy_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


resource "aws_lb_listener_rule" "keycloak_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy_tg.arn
  }

  condition {
    host_header {
      values = ["keycloak.trainee-keycloack.store"]
    }
  }
}


resource "aws_lb_listener_rule" "oauth2_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proxy_tg.arn
  }

  condition {
    host_header {
      values = ["oauth2.trainee-keycloack.store"]
    }
  }
}
