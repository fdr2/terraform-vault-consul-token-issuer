variable "consul_token" {
  type = string
}

variable "backend_name" {
  type    = string
  default = "consul"
}

variable "backend_description" {
  type    = string
  default = "Managed by Terraform"
}

variable "max_lease_ttl_seconds" {
  type    = number
  default = 86400 # 24 hours
}

variable "max_ttl" {
  type    = number
  default = 36000 # 10 hours
}

variable "address" {
  type    = string
  default = "http://consul.service.consul:8500"
}

variable "ttl" {
  type    = number
  default = 14400 # 4 hours
}

variable "consul_policies" {
  type    = list(string)
  default = null
}

variable "consul_roles" {
  type    = list(string)
  default = null
}
