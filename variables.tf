variable "consul_token" {
  description = "Consul Token Vault will use to create Consul Tokens."
  type        = string
}

variable "backend_name" {
  description = "Backend Name for Vault's Consul Secrets Backend."
  type        = string
  default     = "consul"
}

variable "backend_description" {
  description = "Backend Description for Vault's Consul Secrets Backend."
  type        = string
  default     = "Managed by Terraform"
}

variable "default_lease_ttl_seconds" {
  description = "Default Consul Token Lease TTL for the Consul Secrets Backend."
  type        = number
  default     = 3600 # 1 hour
}

variable "max_lease_ttl_seconds" {
  description = "Maximum Consul Token Lease TTL for the Consul Secrets Backend."
  type        = number
  default     = 14400 # 4 hours
}

variable "address" {
  description = "Address of the Consul Servers as resolved by the Vault Agent."
  type        = string
  default     = "consul.service.consul:8501"
}

variable "scheme" {
  description = "Scheme utilized for connecting to Consul Servers."
  type        = string
  default     = "https"
}

variable "consul_ca_cert" {
  description = "Consul CA Certificate used for communicating with Consul. Default will use Vault's system CA."
  type        = string
  default     = null
}

variable "consul_client_cert" {
  description = "Consul Client Certificate used for communicating with Consul. Default will use Vault's system cert."
  type        = string
  default     = null
}

variable "consul_client_key" {
  description = "Consul Client Key used for communicating with Consul. Default will use Vault's system key."
  type        = string
  default     = null
}

variable "consul_roles" {
  description = "Nested configuration of the Consul Roles to be created for use with Vault's Consul Secrets Backend."
  type        = any
  default     = null
}

variable "disable_remount" {
  description = "Should remounting Vault's Consul Secrets Backend be permitted."
  type        = string
  default     = false
}
