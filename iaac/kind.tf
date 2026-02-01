# Create a cluster
resource "kind_cluster" "default" {
  name           = var.cluster_name
  wait_for_ready = true
  node_image     = var.node_image
  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    dynamic "node" {
      for_each = var.nodes[*]
      content {
        role                   = node.value.role
        image                  = node.value.image
        labels                 = node.value.labels
        kubeadm_config_patches = node.value.kubeadm_config_patches
        dynamic "extra_mounts" {
          for_each = node.value.extra_mounts
          content {
            host_path       = extra_mounts.value.host_path
            container_path  = extra_mounts.value.container_path
            read_only       = extra_mounts.value.read_only
            propagation     = extra_mounts.value.propagation
            selinux_relabel = extra_mounts.value.selinux_relabel
          }
        }
        dynamic "extra_port_mappings" {
          for_each = node.value.extra_port_mappings
          content {
            container_port = extra_port_mappings.value.container_port
            host_port      = extra_port_mappings.value.host_port
            protocol       = extra_port_mappings.value.protocol
            listen_address = extra_port_mappings.value.listen_address
          }
        }
      }
    }
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      rm -rf ${self.name}-config
    EOF
  }
  depends_on = [
    null_resource.set_harbor_admin_password
  ]
}
