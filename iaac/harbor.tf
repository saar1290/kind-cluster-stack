# Provisioning Harbor via Docker compose

# Generate self-signed certificate for Harbor
# RSA key of size 4096 bits
resource "tls_private_key" "rsa-4096-harbor" {
  algorithm  = "RSA"
  rsa_bits   = 4096
  depends_on = [null_resource.write_ca_files]
}

# Request self-signed certificate for Harbor
resource "tls_cert_request" "csr_harbor" {
  private_key_pem = tls_private_key.rsa-4096-harbor.private_key_pem
  subject {
    common_name         = var.harbor_hostname
    organization        = var.organization
    organizational_unit = var.organizational_unit
    country             = var.country
    province            = var.province
    locality            = var.locality
  }

  dns_names = [
    var.domain,
    var.harbor_hostname,
    trimsuffix(var.harbor_hostname, ".${var.domain}")
  ]
}

# Signed certificate for Harbor using the CA
resource "tls_locally_signed_cert" "harbor_cert" {
  cert_request_pem   = tls_cert_request.csr_harbor.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.ca_cert.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "key_encipherment",
    "data_encipherment",
    "digital_signature"
  ]
  early_renewal_hours = 168
  is_ca_certificate   = false
}

# Write certificate and private key to file
resource "null_resource" "write_harbor_certificates_files" {
  triggers = {
    harbor_cert   = tls_locally_signed_cert.harbor_cert.cert_pem
    harbor_key    = sensitive(trimspace(tls_private_key.rsa-4096-harbor.private_key_pem))
    ssl_certs_dir = local.ssl_certs_dir
  }
  provisioner "local-exec" {
    quiet   = true
    command = <<EOF
      echo '${self.triggers.harbor_key}' > ${self.triggers.ssl_certs_dir}/harbor.key
      echo '${self.triggers.harbor_cert}' > ${self.triggers.ssl_certs_dir}/harbor.crt
    EOF
  }
}

# Download Harbor installer
resource "null_resource" "harbor_download" {
  triggers = {
    harbor_version          = var.harbor_version
    harbor_installation_dir = local.harbor_installation_dir
  }
  provisioner "local-exec" {
    command = "scripts/download-harbor.sh ${self.triggers.harbor_version} ${self.triggers.harbor_installation_dir}"
  }
  lifecycle {
    replace_triggered_by = [random_password.admin_password]
  }
  depends_on = [tls_locally_signed_cert.harbor_cert]
}

# Install Harbor
resource "null_resource" "harbor_install" {
  triggers = {
    harbor_hostname         = var.harbor_hostname
    harbor_port             = var.harbor_port
    docker_certs_dir        = local.docker_certs_dir
    harbor_data_location    = local.harbor_data_location
    harbor_installation_dir = local.harbor_installation_dir
    sudo                    = var.sudo
  }
  provisioner "local-exec" {
    command = "scripts/install-harbor.sh ${self.triggers.sudo} ${self.triggers.harbor_hostname} ${self.triggers.harbor_port} ${self.triggers.harbor_installation_dir} ${self.triggers.harbor_data_location} ${self.triggers.docker_certs_dir} ${local.ssl_certs_dir}"
  }
  provisioner "local-exec" {
    command = "scripts/install-harbor-service.sh ${self.triggers.harbor_installation_dir} ${self.triggers.sudo}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "scripts/uninstall-harbor.sh ${self.triggers.harbor_installation_dir} ${self.triggers.sudo}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "scripts/harbor-cleanup-db.sh ${self.triggers.harbor_data_location} ${self.triggers.sudo}"
  }
  lifecycle {
    replace_triggered_by = [random_password.admin_password]
  }
  depends_on = [null_resource.harbor_download]
}

# Generate random password for Harbor admin user
resource "random_password" "admin_password" {
  length  = 10
  special = false
  keepers = {
    harbor_version = var.harbor_version
  }
}

# Set Harbor admin password
resource "null_resource" "set_harbor_admin_password" {
  triggers = {
    harbor_hostname    = var.harbor_hostname
    harbor_port        = var.harbor_port
    new_admin_password = random_password.admin_password.result
    admin_password     = local.default_admin_password
  }
  provisioner "local-exec" {
    command = "scripts/set-harbor-admin-password.sh ${self.triggers.harbor_hostname} ${self.triggers.harbor_port} ${self.triggers.new_admin_password} ${self.triggers.admin_password}"
  }
  lifecycle {
    replace_triggered_by = [random_password.admin_password]
  }
  depends_on = [null_resource.harbor_health_check]
}

# Health check for Harbor
resource "null_resource" "harbor_health_check" {
  triggers = {
    harbor_hostname = var.harbor_hostname
    harbor_port     = var.harbor_port
    admin_password  = local.default_admin_password
  }
  provisioner "local-exec" {
    command = "scripts/harbor-health-check.sh ${self.triggers.harbor_hostname} ${self.triggers.harbor_port} ${self.triggers.admin_password}"
  }
  depends_on = [null_resource.harbor_install]
}

# Harbor Projects and Registries
resource "harbor_project" "project" {
  for_each      = { for project in var.harbor_projects : project => project }
  name          = each.value
  force_destroy = true
  depends_on    = [null_resource.set_harbor_admin_password]
}


resource "harbor_project" "proxy_project" {
  for_each    = { for repo in var.remote_repositories : repo.provider => repo }
  name        = each.value.project_name
  registry_id = tonumber(element(split("/", harbor_registry.docker_proxy[each.key].id), length(split("/", harbor_registry.docker_proxy[each.key].id)) - 1))

  depends_on = [harbor_registry.docker_proxy]
}

resource "harbor_registry" "docker_proxy" {
  for_each      = { for repo in var.remote_repositories : repo.provider => repo }
  provider_name = each.value.provider
  name          = "${each.value.provider}-proxy"
  endpoint_url  = each.value.endpoint

  depends_on = [null_resource.set_harbor_admin_password]
}