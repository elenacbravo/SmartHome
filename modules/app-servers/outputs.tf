output "bastion_host_instance_address" {
  value = aws_instance.bastion.public_dns
}
