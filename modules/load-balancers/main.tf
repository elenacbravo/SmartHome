# Public services and their configurations
locals {
  public_services = {
    heating = {
      name         = "heating",
      path_pattern = "/api/heating/*",
      health_check = "/api/heating/health",
      instance_id  = var.heating_service_instance_id
    },
    lighting = {
      name         = "lighting",
      path_pattern = "/api/lights/*",
      health_check = "/api/lights/health",
      instance_id  = var.lighting_service_instance_id
    },
    status = {
      name         = "status",
      path_pattern = "/api/status",
      health_check = "/api/status/health",
      instance_id  = var.status_service_instance_id
    }
  }

  # Private service and its configuration
  private_services = {
    auth = {
      name         = "auth",
      path_pattern = "/api/auth/*",
      health_check = "/api/auth/health",
      instance_id  = var.auth_service_instance_id
    }
  }
}

# Public Load Balancer
resource "aws_lb" "public_services" {
  name               = "smart-home-lb-public"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.public_subnets_ids

  tags = {
    Name = "smart-home-lb-public"
  }
}

resource "aws_lb_listener" "public_services" {
  for_each = local.public_services

  load_balancer_arn = aws_lb.public_services.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
  }
}

resource "aws_lb_target_group" "public_services" {
  for_each = local.public_services

  name     = "${each.value.name}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = each.value.health_check
  }
}

resource "aws_lb_target_group_attachment" "public_services" {
  for_each = local.public_services

  target_group_arn = aws_lb_target_group.public_services[each.key].arn
  target_id        = each.value.instance_id
  port             = 3000
}

resource "aws_lb_listener_rule" "public_services" {
  for_each = local.public_services

  listener_arn = aws_lb_listener.public_services[each.key].arn 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_services[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}

# Private Load Balancer
resource "aws_lb" "private_services" {
  name               = "auth-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.private_security_groups
  subnets            = var.private_subnets_ids

  tags = {
    Name = "auth-lb"
  }
}

resource "aws_lb_target_group" "private_services" {
  for_each = local.private_services

  name     = "${each.value.name}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = each.value.health_check
  }
}

resource "aws_lb_listener" "private_services" {
  for_each = local.private_services

  load_balancer_arn = aws_lb.private_services.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_services[each.key].arn  
  }
}

resource "aws_lb_target_group_attachment" "private_services" {
  for_each = local.private_services

  target_group_arn = aws_lb_target_group.private_services[each.key].arn
  target_id        = each.value.instance_id
  port             = 3000
}

resource "aws_lb_listener_rule" "private_services" {
  for_each = local.private_services

  listener_arn = aws_lb_listener.private_services[each.key].arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_services[each.key].arn
  }

  condition {
    path_pattern {
      values = [each.value.path_pattern]
    }
  }
}