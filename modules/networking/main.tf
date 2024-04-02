# VPC
resource "aws_vpc" "microservices-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway (IGW)
resource "aws_internet_gateway" "microservices" {
  vpc_id = aws_vpc.microservices-vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Subnets 
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.microservices-vpc.id
  cidr_block        = var.public_subnets[count.index].cidr_range
  availability_zone = var.public_subnets[count.index].availability_zone
  map_public_ip_on_launch = var.public_subnets[count.index].map_public_ip_on_launch

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.microservices-vpc.id
  cidr_block        = var.private_subnets[count.index].cidr_range
  availability_zone = var.private_subnets[count.index].availability_zone

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

# Public Route 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.microservices-vpc.id

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
    
  subnet_id = element(aws_subnet.public[*].id , count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public-igw" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.microservices.id
}

# NAT Gateway
resource "aws_eip" "microservices" {
  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }

  depends_on = [ aws_internet_gateway.microservices ]
}

resource "aws_nat_gateway" "microservices" {
  allocation_id = aws_eip.microservices.id
  subnet_id = aws_subnet.public[0].id
  
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }

  depends_on = [ aws_internet_gateway.microservices ]
}


# Private Route
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.microservices-vpc.id
  
  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)

  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_nat_gw" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.microservices.id
}

resource "aws_route" "private_dns64_nat_gw" {
  route_table_id = aws_route_table.private.id

  # Network address translation (ipv6 -> ipv4)
  destination_ipv6_cidr_block = "64:ff9b::/96"
  nat_gateway_id = aws_nat_gateway.microservices.id
}


