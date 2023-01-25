locals {
  test_prefix = "__test"
}

module "vault-consul-token-issuer" {
  source       = "../../"
  backend_name = "${local.test_prefix}_consul"
  consul_token = var.consul_token
  consul_roles = {
    "${local.test_prefix}-ops" : {
      ttl : 86400
      max_ttl : 86400
      roles : [
        "consul-ops"
      ]
    }
    "${local.test_prefix}-consul-server" : {
      policies : [
        "consul-server"
      ]
    }
  }
}
