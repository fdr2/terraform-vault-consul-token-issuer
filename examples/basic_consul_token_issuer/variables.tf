variable "vault_address" {
  type    = string
  default = "https://vault.service.consul:8200"
}

variable "consul_address" {
  type    = string
  default = "https://consul.service.consul:8501"
}

variable "consul_token" {
  type    = string
  default = "00000000-1111-2222-3333-444444444444"
}
