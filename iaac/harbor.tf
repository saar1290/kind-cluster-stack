# Provisioning Harbor via Docker compose

# Generate self-signed certificate for Harbor
# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096-harbor" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Request self-signed certificate for Harbor
resource "tls_cert_request" "csr_harbor" {
  private_key_pem = file(tls_private_key.rsa-4096-harbor.private_key_pem)

  subject {
    common_name  = var.harbor_hostname
    organization = var.organization
    country      = var.country
    province     = var.province
    locality     = var.locality 
  }
  
  dns_names = [
    var.domain,
    var.harbor_hostname
  ]
}

# Signed certificate for Harbor using the CA
resource "tls_locally_signed_cert" "harbor_cert" {
  cert_request_pem   = file(tls_cert_request.csr_harbor.cert_request_pem)
  ca_private_key_pem = file(tls_private_key.rsa-4096-harbor.private_key_pem)
  ca_cert_pem        = file(tls_self_signed_cert.ca_cert.cert_pem)

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
  early_renewal_hours = 168
  is_ca_certificate = false
}

# Download Harbor installer
resource "null_resource" "harbor_download" {
  provisioner "local-exec" {
    command = <<EOF
      curl -L https://github.com/goharbor/harbor/releases/download/${var.harbor_version}/harbor-online-installer-${var.harbor_version}.tgz -o harbor-online-installer-${var.harbor_version}.tgz && \
      tar xvf harbor-online-installer-${var.harbor_version}.tgz
    EOF
  }
  depends_on = [ tls_locally_signed_cert.harbor_cert ]
}

resource "random_password" "admin_password" {
  length  = 16
  special = true
}

# Install Harbor
resource "null_resource" "harbor_install" {
  provisioner "local-exec" {
    command = <<EOF
      cd harbor && \
      cp harbor.yml.tmpl harbor.yml && \
      sed -i 's/hostname = .*/hostname = ${var.harbor_hostname}/' harbor.yml && \
      sed -i 's/harbor_admin_password: .*/harbor_admin_password: ${random_password.admin_password.result}/' harbor.yml && \
      sed -i 's/certificate: .*/certificate: /data/cert.crt' harbor.yml && \
      sed -i 's/private_key: .*/private_key: /data/key.key' harbor.yml && \
      mkdir -p /data && \
      echo "${trimspace(tls_locally_signed_cert.harbor_cert.cert_pem)}" > /data/cert.crt && \
      echo "${tls_private_key.rsa-4096-harbor.private_key_pem}" > /data/key.key && \
      ./install.sh --with-notary --with-trivy --with-clair --with-chartmuseum
    EOF
  }
  depends_on = [ null_resource.harbor_download ]
}