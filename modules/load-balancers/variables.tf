variable "security_groups" {
  type = list(string)
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "heating_service_instance_id" {
  type = string
}

variable "lighting_service_instance_id" {
  type = string
}

