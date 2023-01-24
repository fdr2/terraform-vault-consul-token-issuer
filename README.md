# Terraform Vault Consul Token Issuer

Configure Vault's Consul Credential Engine with Nomad.

Issues a Consul token with the attached Consul policy.

> This module aligns with [Administer Consul Access Control Tokens with Vault](https://developer.hashicorp.com/consul/tutorials/vault-secure/vault-consul-secrets)

## Usage
Add the module and assign a consul policy for the tokens that will be issued.

```terraform
module "vault-consul-token-issuer" {
  source      = "./modules/terraform-vault-consul-token-issuer"
  nomad_token = var.nomad_token
  policies    = ["consul-ops"]
}

resource "vault_policy" "consul-ops" {
  name     = "consul-ops"
  policy   = file("policies/consul-ops.hcl")
}
```

## Contributors Prerequisites

Terraform Code Utilities
```bash
brew tap liamg/tfsec
brew install terraform-docs tflint tfsec checkov
brew install pre-commit gawk coreutils go
```

Add the following to your `~/.profile`, if it is not already there.
You can check if they already exist by executing `env`.
```bash
# Go
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
export PATH=$PATH:$GOBIN
```

Then reload your profile.
```bash
. ~/.profile
```

Ensure `golint` is properly installed with PATHs set properly from above.
```bash
go get -u golang.org/x/lint/golint
```

To manually run the pre-commit hooks
```bash
pre-commit run -a
```

### Tests
Login to Vault or issue a runner a VAULT_TOKEN environment variable.
```bash
VAULT_HOST=https://vault.service.consul:8200 vault login -method=ldap username=$USER
```

Ensure you have Go >= 1.19.5
[Read more about terratest](https://terratest.gruntwork.io/docs/getting-started/quick-start/)
```bash
cd test/main
go test
```

## TODO

* write local vault dev example
* write tests

