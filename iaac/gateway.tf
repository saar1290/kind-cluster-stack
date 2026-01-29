# Install Gateway API CRDs
resource "null_resource" "gateway_api_crds" {
  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml"
  }
  
  depends_on = [
    kind_cluster.default
  ]
}

# Create Certificate for Gateway TLS
resource "kubectl_manifest" "gateway_certificate" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: kind-cluster-tls
  namespace: kube-system
spec:
  secretName: kind-cluster-tls
  issuerRef:
    name: ca-issuer
    kind: ClusterIssuer
  dnsNames:
  - "*.${var.domain}"
  - "${var.domain}"
YAML
  depends_on = [
    kubectl_manifest.cert_manager_cluster_issuer,
    null_resource.gateway_api_crds
  ]
}

# Provisioning Gateway API for kind cluster
resource "kubectl_manifest" "gateway_api_kind_cluster" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: global-api-gateway
  namespace: kube-system
  annotations:
    cert-manager.io/cluster-issuer: ca-issuer
spec:
  gatewayClassName: cloud-provider-kind
  listeners:
  - protocol: HTTPS
    port: 443
    name: https
    tls:
      mode: Terminate
      certificateRefs:
      - name: kind-cluster-tls
        kind: Secret
    allowedRoutes:
      namespaces:
        from: All # Allows routes from all namespaces
YAML
  depends_on = [
    null_resource.gateway_api_crds,
    kind_cluster.default,
    docker_container.cloud_provider_kind_start,
    helm_release.cert_manager,
    kubectl_manifest.gateway_certificate
  ]
}