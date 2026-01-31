# Provision cert-manager using Helm
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = var.cert_manager_version
  namespace        = "cert-manager"
  create_namespace = true
  values = [
    file("${path.module}/cert-manager/values.yaml")
  ]
  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
  depends_on = [kind_cluster.default]
}

# Generate private key for cert-manager subCA
resource "tls_private_key" "rsa-4096-cert-manager" {
  algorithm  = "RSA"
  rsa_bits   = 4096
  depends_on = [helm_release.cert_manager]
}

# Request certificate for cert-manager subCA
resource "tls_cert_request" "csr_cert_manager" {
  private_key_pem = tls_private_key.rsa-4096-cert-manager.private_key_pem

  subject {
    common_name         = "cert-manager-ca"
    organization        = var.organization
    organizational_unit = var.organizational_unit
    country             = var.country
    province            = var.province
    locality            = var.locality
  }
}

# Signed subCA certificates for cert-manager using the CA
resource "tls_locally_signed_cert" "cert_manager_ca_cert" {
  cert_request_pem   = tls_cert_request.csr_cert_manager.cert_request_pem
  ca_private_key_pem = tls_self_signed_cert.ca_cert.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  allowed_uses = [
    "cert_signing"
  ]
  validity_period_hours = 43800 # 5 years
  early_renewal_hours   = 168
  is_ca_certificate     = true
}

# Write certificate and private key to file
resource "null_resource" "write_cert-manager_certificates_files" {
  triggers = {
    ca_certificate           = tls_self_signed_cert.ca_cert.cert_pem
    cert_manager_ca_cert     = tls_locally_signed_cert.cert_manager_ca_cert.cert_pem
    cert_manager_private_key = tls_private_key.rsa-4096-cert-manager.private_key_pem
    ssl_certs_dir            = local.ssl_certs_dir
  }
  provisioner "local-exec" {
    quiet   = true
    command = <<EOF
      echo '${sensitive(trimspace(self.triggers.cert_manager_private_key))}' > ${self.triggers.ssl_certs_dir}/cert-manager.key
      echo '${self.triggers.cert_manager_ca_cert}' '${self.triggers.ca_certificate}' > ${self.triggers.ssl_certs_dir}/cert-manager.crt
    EOF
  }
}

# Create a Kubernetes secret to store the cert-manager CA certificate and private key
resource "kubernetes_secret_v1" "cert_manager_ca_secret" {
  metadata {
    name      = "ca-secret"
    namespace = "cert-manager"
  }
  data = {
    "tls.crt" = tls_locally_signed_cert.cert_manager_ca_cert.cert_pem
    "tls.key" = tls_private_key.rsa-4096-cert-manager.private_key_pem
  }
  type = "Opaque"
}

# Create a cert-manager Cluster Issuer using the CA secret
resource "kubectl_manifest" "cert_manager_cluster_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ca-issuer
  namespace: cert-manager
spec:
  ca:
    secretName: ${kubernetes_secret_v1.cert_manager_ca_secret.metadata[0].name}
YAML
  depends_on = [
    helm_release.cert_manager,
    kubernetes_secret_v1.cert_manager_ca_secret,
    kind_cluster.default
  ]
}