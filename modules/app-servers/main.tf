# Bastion
resource "aws_instance" "bastion" {
  ami                    = "ami-0d18e50ca22537278"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.bastion_sg
  key_name               = "smarthome-apps"

  tags = {
    Name = "bastion-host-smarthome"
  }
}

# Lighting
resource "aws_instance" "lighting" {
  ami                    = "ami-0d18e50ca22537278"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.public_sg

  tags = {
    Name = "lighting-app-server"
  }
}

# Heating
resource "aws_instance" "heating" {
  ami                    = "ami-0d18e50ca22537278"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.public_sg

  tags = {
    Name = "heating-app-server"
  }
}

locals {
  vars = {
    heating  = aws_instance.heating.private_ip
    lighting = aws_instance.lighting.private_ip
    auth     = aws_instance.auth.private_ip
  }
}

# Status
resource "aws_instance" "status" {
  ami                    = "ami-0d18e50ca22537278"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = var.public_sg

  tags = {
    Name = "status-app-server"
  }

  user_data = base64decode(templatefile("${path.module}/user_data.sh", local.vars))

  depends_on = [aws_instance.heating, aws_instance.auth, aws_instance.lighting]
}

# Auth
resource "aws_instance" "auth" {
  ami                    = "ami-0d18e50ca22537278"
  instance_type          = "t2.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = var.private_sg

  tags = {
    Name = "auth-app-server"
  }
}
