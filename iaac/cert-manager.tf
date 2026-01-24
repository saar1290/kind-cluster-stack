# Provision cert-manager using Helm
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = var.cert_manager_version
  namespace  = "cert-manager"
  create_namespace = true
  set = [
    {
      name  = "installCRDs"
      value = "true"
    }
  ]
  depends_on = [ kind_cluster.default ]
}

# Generate private key for cert-manager subCA
resource "tls_private_key" "rsa-4096-cert-manager" {
  algorithm = "RSA"
  rsa_bits  = 4096
  depends_on = [ helm_release.cert_manager ]
}

# Request certificate for cert-manager subCA
resource "tls_cert_request" "csr_cert_manager" {
  private_key_pem = file(tls_private_key.rsa-4096-cert-manager.private_key_pem)
  
  subject {
    common_name  = "cert-manager-ca"
    organization = var.organization
    country      = var.country
    province     = var.province
    locality     = var.locality 
  }

  dns_names = [
    "cert-manager.${var.domain}",
    "cert-manager-ca.${var.domain}"
  ]
}

# Signed subCA certificates for cert-manager using the CA
resource "tls_locally_signed_cert" "cert_manager_ca_cert" {
  cert_request_pem   = file(tls_cert_request.csr_cert_manager.cert_request_pem)
  ca_private_key_pem = file(tls_private_key.rsa-4096-cert-manager.private_key_pem)
  ca_cert_pem        = file(tls_self_signed_cert.ca_cert.cert_pem)

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
  ]
  early_renewal_hours = 168
  is_ca_certificate = true
}

# Create a Kubernetes secret to store the cert-manager CA certificate and private key
resource "kubernetes_secret" "cert_manager_ca_secret" {
  metadata {
    name      = "cert-manager-ca-secret"
    namespace = "cert-manager"
  }
  data = {
    "ca.crt" = trimspace(tls_locally_signed_cert.cert_manager_ca_cert.cert_pem)
    "ca.key" = tls_private_key.rsa-4096-cert-manager.private_key_pem
  }
  type = "Opaque"
}

# Create a cert-manager Cluster Issuer using the CA secret
resource "kubernetes_manifest" "cert_manager_cluster_issuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "ca-issuer"
    }
    "spec" = {
      "ca" = {
        "secretName" = kubernetes_secret.cert_manager_ca_secret.metadata[0].name
      }
    }
  }
}