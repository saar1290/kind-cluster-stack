# Provisioning Gateway API for kind cluster
resource "kubectl_manifest" "gateway_api_kind_cluster" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: global-api-gateway
  namespace: kube-system
spec:
  gatewayClassName: cloud-provider-kind
  listeners:
  - protocol: HTTPS
    port: 443
    name: https
    tls:
      mode: Terminate
      certificateRefs:
      - name: cert-manager/ca-secret
    allowedRoutes:
      namespaces:
        from: Same
YAML
  depends_on = [
    kind_cluster.default,
    docker_container.cloud_provider_kind_start,
    helm_release.cert_manager
  ]
}