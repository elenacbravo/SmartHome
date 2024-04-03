# VPC 
vpc_name             = "smart-home-microservices-vpc"
vpc_cidr_block       = "10.0.0.0/20"
enable_dns_hostnames = true

public_subnets = [{
  cidr_range              = "10.0.0.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  }, {
  cidr_range              = "10.0.1.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true
  }, {
  cidr_range              = "10.0.2.0/24"
  availability_zone       = "eu-west-2c"
  map_public_ip_on_launch = true
}]

private_subnets = [{
  cidr_range        = "10.0.10.0/24"
  availability_zone = "eu-west-2a"
  }, {
  cidr_range        = "10.0.11.0/24"
  availability_zone = "eu-west-2b"
  }, {
  cidr_range        = "10.0.12.0/24"
  availability_zone = "eu-west-2c"
}]

# Security
allowed_ips = ["X.X.X.X/32"]  # Replace it with your IP address or IP ranges allowed for SSH access

