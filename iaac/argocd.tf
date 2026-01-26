# Provision Argocd via Helm
resource "helm_release" "argocd" {
  chart            = "argo-cd"
  name             = "argocd"
  version          = var.argocd_version
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  create_namespace = true
  values = [
    file("${path.module}/argocd/values.yaml")
  ]
  set = [
    {
      name  = "server.ingress.hostname"
      value = var.argocd_hostname
    },
    {
      name  = "server.ingress.tls"
      value = "true"
    },
    {
      name  = "server.ingressGrpc.hostname"
      value = var.argocd_hostname
    },
    {
      name  = "server.ingressGrpc.tls"
      value = "true"
    }
  ]
  depends_on = [helm_release.vault]
}