
# consul reload
# consul leave
agent_prefix "" {
  policy = "write"
}

# consul monitor
agent_prefix "" {
  policy = "read"
}

# consul members
# consul catalog nodes
# consul services register (part 1)
node_prefix "" {
  policy = "read"
}

# Allow register/deregister services on nodes
node_prefix "" {
  policy = "write"
}

# consul acl
acl = "write"
# consul keyring
keyring = "write"
# consul mesh
mesh = "write"
# peering
peering = "write"
# operator
operator = "write"

# consul catalog services
service_prefix "" {
  policy = "read"
}

# consul services register
# consul services register (part 2)
service_prefix "" {
  policy = "write"
}

# consul connect intention (Enterprise Only)
#service_prefix "" {
#  intention = "write"
#}

# consul kv get
key_prefix "" {
  policy = "read"
}

# consul kv put
key_prefix "" {
  policy = "write"
}

# dont allow operators to read sensitive consul kv store
key_prefix "consul" {
  policy = "read"
}

# dont allow operators to read sensitive vault kv store
key_prefix "vault" {
  policy = "read"
}

event_prefix "" {
  policy = "read"
}

event_prefix "" {
  policy = "write"
}

query_prefix "" {
  policy = "read"
}

session_prefix "" {
  policy = "read"
}

# for exec on nodes
session_prefix "" {
  policy = "write"
}

# for exec on consul nodes
#session_prefix "consul" {
#  policy = "write"
#}

## Token Management


# TLS Management


# All kv Management
path "kv" {
  capabilities = [ "create", "read", "update", "patch", "list", "delete" ]
}

## KV Storage for TLS
#path "kv/config/consul/tls/*" {
#  capabilities = [ "create", "read", "update", "patch", "list" ]
#}
## KV Storage for Vault Tokens
#path "kv/config/consul/token/*" {
#  capabilities = [ "create", "read", "update", "patch", "list" ]
#}

## KV Storage for TLS
#path "kv/config/vault/tls/*" {
#  capabilities = [ "create", "read", "update", "patch", "list" ]
#}
## KV Storage for Vault Tokens
#path "kv/config/vault/token/*" {
#  capabilities = [ "create", "read", "update", "patch", "list" ]
#}



