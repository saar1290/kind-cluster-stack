resource "kubectl_manifest" "vault_route" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: vault-route
  namespace: vault
spec:
  parentRefs:
  - name: global-api-gateway
  hostnames:
  - "${var.vault_hostname}"
  rules:
    - matches:
      - path:
          type: PathPrefix
          value: /
      backendRefs:
      - name: vault-ui
        port: 8200
        weight: 100
YAML
  depends_on = [
    docker_container.cloud_provider_kind_start,
    helm_release.cert_manager,
    helm_release.vault,
    kubectl_manifest.gateway_api_kind_cluster
  ]
}

resource "kubectl_manifest" "argocd_route" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: argocd-route
  namespace: argocd
spec:
  parentRefs:
  - name: global-api-gateway
  hostnames:
  - "${var.argocd_hostname}"
  rules:
    - matches:
      - path:
          type: PathPrefix
          value: /
      backendRefs:
      - name: argocd-server
        port: 443
        weight: 100
YAML
  depends_on = [
    docker_container.cloud_provider_kind_start,
    helm_release.cert_manager,
    helm_release.argocd,
    helm_release.vault,
    kubectl_manifest.gateway_api_kind_cluster
  ]
}