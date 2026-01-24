# Provision cloud-provider-kind using Docker

# Cloning the cloud-provider-kind repository
resource "null_resource" "cloud_provider_kind_clone" {
  provisioner "local-exec" {
    command = "git clone https://github.com/kubernetes-sigs/cloud-provider-kind.git"
  }
  depends_on = [ null_resource.harbor_install ]
}

# Build a Docker image from a Dockerfile
resource "docker_image" "cloud_provider_kind_build" {
  name = "${var.harbor_hostname}/${var.harbor_project}/cloud-provider-kind:latest"
  build {
    context = "${path.module}/cloud-provider-kind/."
  }
  depends_on = [ null_resource.cloud_provider_kind_clone ]
}

# Push the image to a registry
resource "docker_registry_image" "pushed_image" {
  name          = docker_image.cloud_provider_kind_build.name
  keep_remotely = true
}

# Find the latest cloud-provider-kind image.
resource "docker_image" "cloud_provider_kind_latest" {
  name = "${var.harbor_hostname}/${var.harbor_project}/cloud-provider-kind:latest"
  depends_on = [ docker_registry_image.pushed_image ]
}

# Start a container
resource "docker_container" "cloud_provider_kind_start" {
  name  = "cloud-provider-kind"
  image = docker_image.cloud_provider_kind_build.image_id
}
