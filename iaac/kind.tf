# Create a cluster
resource "kind_cluster" "default" {
  name           = var.cluster_name
  wait_for_ready = true
  node_image     = var.node_image
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    node {
      role = "control-plane"
    }
    node {
      role = "control-plane"
    }
    node {
      role = "control-plane"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
    node {
      role = "worker"
    }
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      rm -rf ${self.name}-config
    EOF
  }
  depends_on = [
    docker_registry_image.pushed_image,
    docker_container.cloud_provider_kind_start
  ]
}
