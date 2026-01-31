# Install Gateway API CRDs
resource "null_resource" "gateway_api_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml"
  }

  depends_on = [
    kind_cluster.default
  ]
}

# Provisioning Gateway API for kind cluster
resource "kubectl_manifest" "global_gateway" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: global-gateway
  namespace: kube-system
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
spec:
  gatewayClassName: cloud-provider-kind
  listeners:
  - name: https
    hostname: "*.${var.domain}"
    protocol: HTTPS
    port: 443
    tls:
      mode: Terminate
      certificateRefs:
      - name: global-tls-cert
        kind: Secret
    allowedRoutes:
      namespaces:
        from: All
YAML
  depends_on = [
    null_resource.gateway_api_crds,
    kind_cluster.default,
    docker_container.cloud_provider_kind_start,
    helm_release.cert_manager,
  ]
}