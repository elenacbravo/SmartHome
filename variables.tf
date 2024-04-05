variable "vpc_cidr_block" {
  type        = string
  description = "value"
}

variable "vpc_name" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "public_subnets" {
  type = list(object({
    cidr_range              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
  }))
}

variable "private_subnets" {
  type = list(object({
    cidr_range        = string
    availability_zone = string
  }))
}

variable "allowed_ips" {
  description = "IP addresses or IP ranges allowed for SSH access"
  type        = list(string)
}

variable "table_names" {
  type = list(string)
}

variable "hash_key" {
  type = string
}

variable "hash_key_type" {
  type = string
}

