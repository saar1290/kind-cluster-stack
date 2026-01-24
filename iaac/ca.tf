# Generate CA certificate and private key and public key

# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write private key to file
resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = file(tls_private_key.rsa-4096-example.private_key_pem)

  subject {
    common_name  = var.ca_common_name
    organization = var.organization
    country      = var.country
    province     = var.province
    locality     = var.locality
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  early_renewal_hours = 168
  is_ca_certificate = true
}