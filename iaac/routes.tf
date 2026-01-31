# resource "kubectl_manifest" "vault_route" {
#   yaml_body = <<YAML
# apiVersion: gateway.networking.k8s.io/v1
# kind: HTTPRoute
# metadata:
#   name: vault-route
#   namespace: vault
# spec:
#   parentRefs:
#   - name: global-api-gateway
#     namespace: kube-system
#   # hostnames:
#   # - "${var.vault_hostname}"
#   rules:
#     - matches:
#       - path:
#           type: PathPrefix
#           value: /
#       backendRefs:
#       - name: vault-ui
#         port: 8200
#         weight: 100
# YAML
#   depends_on = [
#     kind_cluster.default,
#     docker_container.cloud_provider_kind_start,
#     helm_release.cert_manager,
#     helm_release.vault
#   ]
# }

# resource "kubectl_manifest" "argocd_grpc_route" {
#   yaml_body = <<YAML
# apiVersion: gateway.networking.k8s.io/v1
# kind: GRPCRoute
# metadata:
#   name: argocd-grpc-route
#   namespace: argocd
# spec:
#   parentRefs:
#   - name: argocd-gateway
#     namespace: argocd
#   hostnames:
#   - "argocd-grpc.${var.domain}"
#   rules:
#   - backendRefs:
#     - name: argocd-server
#       port: 80
#       weight: 100
# YAML
#   depends_on = [
#     kind_cluster.default,
#     docker_container.cloud_provider_kind_start,
#     helm_release.cert_manager,
#     helm_release.argocd
#   ]
# }