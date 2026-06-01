
resource "aws_lb" "main_alb" {
  name               = "proxy-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.alb_sg_ids
  subnets            = var.public_subnet_ids

  tags = {
    Name = "main-alb-t4"
  }
}


resource "aws_lb_target_group" "proxy_tg" {
  name     = "proxy-target-group"
  port     = var.proxy_listener_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "${var.proxy_listener_port}"
  }

  tags = {
    Name = "proxy-tg-t4"
  }
}


resource "aws_lb_target_group_attachment" "proxy_attach" {
  target_group_arn = aws_lb_target_group.proxy_tg.arn
  target_id        = var.proxy_server_instance_id
  port             = var.proxy_listener_port
}


# resource "aws_lb_listener" "https_listener" {
#   load_balancer_arn = aws_lb.main_alb.arn
#   port              = var.alb_listener_https_port
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"

#   certificate_arn   = var.https_certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.proxy_tg.arn
#   }

#   tags = {
#     Name = "https-listener-main-alb-t4"
#   }
# }


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = var.alb_listener_http_port
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "${var.alb_listener_https_port}"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Name = "http-listener-main-alb-t4"
  }
}


# resource "aws_lb_listener_rule" "keycloak_rule" {
#   listener_arn = aws_lb_listener.https_listener.arn
#   priority     = 10

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.proxy_tg.arn
#   }

#   condition {
#     host_header {
#       values = ["keycloak.trainee-keycloack.store"]
#     }
#   }

#   tags = {
#     Name = "keycloak-listener-rule-main-alb-t4"
#   }
# }


# resource "aws_lb_listener_rule" "oauth2_rule" {
#   listener_arn = aws_lb_listener.https_listener.arn
#   priority     = 20

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.proxy_tg.arn
#   }

#   condition {
#     host_header {
#       values = ["oauth2.trainee-keycloack.store"]
#     }
#   }

#   tags = {
#     Name = "oauth2-listener-rule-main-alb-t4"
#   }
# }
