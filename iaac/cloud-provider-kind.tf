# Provision cloud-provider-kind using Docker

# Cloning the cloud-provider-kind repository
resource "null_resource" "cloud_provider_kind_clone" {
  provisioner "local-exec" {
    quiet   = true
    command = <<EOF
      mkdir -p cloud-provider-kind
      cd cloud-provider-kind
      git clone https://github.com/kubernetes-sigs/cloud-provider-kind.git .
    EOF
  }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      rm -rf cloud-provider-kind
    EOF
  }
  depends_on = [null_resource.harbor_health_check]
}

# Build a Docker image from a Dockerfile
resource "docker_image" "cloud_provider_kind_build" {
  name = "${var.harbor_hostname}/${var.harbor_project}/cloud-provider-kind:latest"
  build {
    context = "cloud-provider-kind/."
  }
  depends_on = [null_resource.cloud_provider_kind_clone]
}

# Push the image to a registry
resource "docker_registry_image" "pushed_image" {
  name                 = docker_image.cloud_provider_kind_build.name
  insecure_skip_verify = true
}

# Start a container
resource "docker_container" "cloud_provider_kind_start" {
  name  = "cloud-provider-kind"
  image = docker_image.cloud_provider_kind_build.image_id
  mounts {
    source = "/var/run/docker.sock"
    target = "/var/run/docker.sock"
    type   = "bind"
  }
  network_mode = "kind"
  depends_on = [ docker_registry_image.pushed_image ]
}