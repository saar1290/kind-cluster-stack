# Provisoning Vault using Helm Chart
resource "helm_release" "vault" {
  name             = "vault"
  repository       = "https://helm.releases.hashicorp.com"
  chart            = "vault"
  version          = var.vault_version
  namespace        = "vault"
  create_namespace = true
  values = [
    file("${path.module}/vault/values.yaml")
  ]
  set = [
    {
      name  = "server.ingress.hosts[0].host"
      value = var.vault_hostname
    },
    {
      name  = "server.ingress.tls[0].hosts[0]"
      value = var.vault_hostname
    },
    {
      name  = "server.ingress.tls[0].secretName"
      value = "vault-tls"
    },
    {
      name  = "server.ha.enabled"
      value = "true"
    },
    {
      name  = "server.ha.raft.enabled"
      value = "true"
    },
    {
      name  = "server.ha.raft.setNodeId"
      value = "true"
    },
    {
      name  = "ui.enabled"
      value = "true"
    },
    {
      name  = "csi.enabled"
      value = "true"
    }
  ]

  depends_on = [
    kind_cluster.default,
    helm_release.cert_manager
  ]
}