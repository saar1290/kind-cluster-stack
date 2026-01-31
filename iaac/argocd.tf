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
  # set = [
  # {
  #   name = "server.httproute.hostnames[0]"
  #   value = var.argocd_hostname
  # },
  # {
  #   name = "server.grpcroute.hostnames[0]"
  #   value = var.argocd_grpc_hostname
  # }
  # ]
  depends_on = [
    kind_cluster.default,
    helm_release.cert_manager,
    helm_release.vault
  ]
}