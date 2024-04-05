# Bastion
resource "aws_instance" "bastion" {
  ami = "ami-0d18e50ca22537278"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = var.bastion_sg

  tags = {
    Name = "bastion-host-smarthome"
  }
}

# Lighting
resource "aws_instance" "lighting" {
  ami = "ami-0d18e50ca22537278"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = var.public_sg

  tags = {
    Name = "lighting-app-server"
  }
}

# Heating
resource "aws_instance" "heating" {
  ami = "ami-0d18e50ca22537278"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = var.public_sg

  tags = {
    Name = "heating-app-server"
  }
}


# Status
resource "aws_instance" "status" {
  ami = "ami-0d18e50ca22537278"
  instance_type = "t2.micro"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = var.public_sg

  tags = {
    Name = "status-app-server"
  }
}

# Auth
resource "aws_instance" "auth" {
  ami = "ami-0d18e50ca22537278"
  instance_type = "t2.micro"
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = var.private_sg

  tags = {
    Name = "auth-app-server"
  }
}