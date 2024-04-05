output "bastion_host_instance_address" {
  value = aws_instance.bastion.public_dns
}

output "lighting_id" {
  value = aws_instance.lighting.id
}

output "heating_id" {
  value = aws_instance.heating.id
}

output "status_id" {
  value = aws_instance.status.id
}

output "auth_id" {
  value = aws_instance.auth.id
}

