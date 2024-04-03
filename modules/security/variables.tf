variable "vpc_id" {
  type = string
}

variable "allowed_ips" {
  description = "IP addresses or IP ranges allowed for SSH access"
  type        = list(string)
}
