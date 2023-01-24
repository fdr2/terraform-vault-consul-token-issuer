locals {
  test_prefix = "__test"
}

module "vault-consul-token-issuer" {
  source       = "../../"
  backend_name = "${local.test_prefix}_consul"
  address      = var.consul_address
  consul_token = var.consul_token
  consul_roles = ["${local.test_prefix}_consul_policy"]
}
