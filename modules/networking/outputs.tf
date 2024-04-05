output "vpc_id" {
  value = aws_vpc.microservices-vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[0].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[0].id
}