variable "instance_type" {
  type        = string
  description = "type of instance"
}
variable "latest_ubuntu" {
  type        = string
}

variable "security_group_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
}

variable "target_group" {
  type        = list(string)
}

variable "desired_capacity" {
  type        = string
}

variable "max_size" {
  type        = string
}

variable "min_size" {
  type        = string
}