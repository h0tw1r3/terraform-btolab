output "rsa" {
  value = tls_private_key.rsa
  sensitive = true
}

output "ecdsa" {
  value = tls_private_key.ecdsa
  sensitive = true
}

output "ed25519" {
  value = tls_private_key.ed25519
  sensitive = true
}
