output "load_balancer_address" {
  value = aws_lb.public_services.dns_name
}