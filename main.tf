# Consul secrets backend, allows Consul ACL tokens to be retrieved through Vault
resource "vault_consul_secret_backend" "this" {
  path                  = var.backend_name
  description           = var.backend_description
  max_lease_ttl_seconds = var.max_lease_ttl_seconds
  address               = var.address
  token                 = var.consul_token
}

resource "vault_consul_secret_backend_role" "this" {
  backend         = vault_consul_secret_backend.this.path
  name            = var.backend_name
  consul_policies = var.consul_policies
  consul_roles    = var.consul_roles
  ttl             = var.ttl
  max_ttl         = var.max_ttl
}
