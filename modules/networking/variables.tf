variable "vpc_cidr_block" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "public_subnets" {
  type = list(object({
    cidr_range        = string
    availability_zone = string
    map_public_ip_on_launch = bool
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr_range        = string
    availability_zone = string
  }))
}