output "load_balancer_address" {
  value = aws_lb.public_services.dns_name
}

output "public_target_group_arn" {
    value = aws_lb_target_group.public_services[*].arn
  }
