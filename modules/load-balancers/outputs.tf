output "load_balancer_address" {
  value = aws_lb.public.dns_name
}