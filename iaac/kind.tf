# Create a cluster
resource "kind_cluster" "default" {
    name = var.cluster_name
    wait_for_ready = true
    node_image = var.node_image
    kind_config = file("${path.module}/kind/kind-config.yaml")
    depends_on = [ docker_container.cloud_provider_kind_start ]
}
