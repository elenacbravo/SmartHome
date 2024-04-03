# Bastion Host Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  // allows SSH inbound from your IP address/specific range of IP addresses
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips # configure it in terraform.tfvars
  }

  // allows outbound traffic to the internet on ports 80 (HTTP) and 443 (HTTPS)
  egress {
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Public Instances Security Group
resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Security group for public EC2 instances"
  vpc_id      = var.vpc_id

  // allows SSH inbound from the bastion host
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }

  // allows inbound HTTP (port 80) and HTTPS (port 443) traffic from the bastion host
  ingress {
    from_port        = 80
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }

}

# Private Instances Security Group
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private EC2 instances"
  vpc_id      = var.vpc_id

  // allows SSH inbound from the bastion host's security group
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }

  // allows inbound HTTP (port 80) and HTTPS (port 443) traffic from the bastion host
  ingress {
    from_port        = 80
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }
  
}
