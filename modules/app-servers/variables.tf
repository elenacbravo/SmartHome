variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "bastion_sg" {
  type = list(string)
}

variable "public_sg" {
  type = list(string)
}

variable "private_sg" {
  type = list(string)
}