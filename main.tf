# Consul secrets backend, allows Consul ACL tokens to be retrieved through Vault
resource "vault_consul_secret_backend" "this" {
  path                      = var.backend_name
  description               = var.backend_description
  disable_remount           = var.disable_remount
  default_lease_ttl_seconds = var.default_lease_ttl_seconds
  max_lease_ttl_seconds     = var.max_lease_ttl_seconds
  address                   = var.address
  scheme                    = var.scheme
  token                     = var.consul_token
  ca_cert                   = var.consul_ca_cert
  client_cert               = var.consul_client_cert
  client_key                = var.consul_client_key
}

resource "vault_consul_secret_backend_role" "this" {
  for_each           = var.consul_roles
  backend            = vault_consul_secret_backend.this.path
  name               = each.key
  consul_policies    = try(each.value["policies"], null)
  consul_roles       = try(each.value["roles"], null)
  service_identities = try(each.value["service_identities"], null)
  node_identities    = try(each.value["node_identities"], null)
  ttl                = try(each.value["ttl"], null)
  max_ttl            = try(each.value["max_ttl"], null)
  local              = try(each.value["local"], false)
}
