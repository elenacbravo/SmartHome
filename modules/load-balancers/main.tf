resource "aws_lb" "public" {
  name               = "smart-home-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets_ids

  tags = {
    Name = "smart-home-lb"
  }
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
  }
}

# Heating
resource "aws_lb_target_group" "heating" {
  name     = "heating-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "api/heating/health"
  }
}

resource "aws_lb_target_group_attachment" "heating_ga" {
  target_group_arn = aws_lb_target_group.heating.arn
  target_id        = var.heating_service_instance_id
  port             = 3000
}

resource "aws_lb_listener_rule" "heating" {
  listener_arn = aws_lb_listener.public.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.heating.arn
  }

  condition {
    path_pattern {
      values = ["/api/heating/*"]
    }
  }
}

# Lighting
resource "aws_lb_target_group" "lighting" {
  name     = "lighting-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "api/lights/health"
  }
}

resource "aws_lb_target_group_attachment" "lighting_ga" {
  target_group_arn = aws_lb_target_group.lighting.arn
  target_id        = var.lighting_service_instance_id
  port             = 3000
}

resource "aws_lb_listener_rule" "lighting" {
  listener_arn = aws_lb_listener.public.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lighting.arn
  }

  condition {
    path_pattern {
      values = ["api/lights/*"]
    }
  }
}

# Status
resource "aws_lb_target_group" "status" {
  name = "status-tg"
  port = 3000
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/api/status/health"
  }
}

resource "aws_lb_target_group_attachment" "status" {
  target_group_arn = aws_lb_target_group.status
  target_id = var.status_service_instance_id
  port = 3000
}

resource "aws_lb_listener_rule" "status" {
  listener_arn = aws_lb_listener.public.arn

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.status.arn
  }

  condition {
    path_pattern {
      values = ["/api/status"]
    }
  }
}
