# Generate CA certificate and private key and public key

# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096-ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Write private key to file
resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem = tls_private_key.rsa-4096-ca.private_key_pem

  subject {
    common_name         = var.ca_common_name
    organization        = var.organization
    organizational_unit = var.organizational_unit
    country             = var.country
    province            = var.province
    locality            = var.locality
  }
  validity_period_hours = 87600 # 10 years
  early_renewal_hours   = 168
  is_ca_certificate     = true
  allowed_uses          = []
}

resource "null_resource" "write_ca_files" {
  triggers = {
    ca_cert          = tls_self_signed_cert.ca_cert.cert_pem
    ca_key           = sensitive(trimspace(tls_private_key.rsa-4096-ca.private_key_pem))
    ssl_certs_dir    = local.ssl_certs_dir
    docker_certs_dir = local.docker_certs_dir
  }
  provisioner "local-exec" {
    quiet   = true
    command = <<EOF
      mkdir -p ${self.triggers.ssl_certs_dir}
      mkdir -p ${self.triggers.docker_certs_dir}
      echo '${self.triggers.ca_key}' > ${self.triggers.ssl_certs_dir}/ca.key
      echo '${self.triggers.ca_cert}' > ${self.triggers.ssl_certs_dir}/ca.crt
    EOF
  }
  provisioner "local-exec" {
    when    = destroy
    command = "scripts/clean-certificates.sh ${self.triggers.ssl_certs_dir} ${self.triggers.docker_certs_dir}"
  }
}

resource "null_resource" "install_ca_certificates" {
  triggers = {
    ssl_certs_dir = local.ssl_certs_dir
    sudo          = var.sudo
  }
  provisioner "local-exec" {
    command = "scripts/install-ca-certificates.sh ${self.triggers.ssl_certs_dir} ${self.triggers.sudo}"
  }
  depends_on = [null_resource.write_ca_files]
}