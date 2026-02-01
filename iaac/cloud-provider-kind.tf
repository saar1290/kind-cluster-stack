# Provision cloud-provider-kind using Docker

# Cloning the cloud-provider-kind repository
resource "null_resource" "cloud_provider_kind_clone" {
  triggers = {
    cloud_provider_kind_dir = local.cloud_provider_kind_dir
  }
  provisioner "local-exec" {
    quiet   = true
    command = "scripts/download-cpk.sh ${self.triggers.cloud_provider_kind_dir}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${self.triggers.cloud_provider_kind_dir}"
  }
  depends_on = [kind_cluster.default]
}

# Build a Docker image from a Dockerfile
resource "docker_image" "cloud_provider_kind_build" {
  name = "${var.harbor_hostname}:${var.harbor_port}/eco-system/cloud-provider-kind:latest"
  build {
    context = "${local.cloud_provider_kind_dir}/."
  }
  depends_on = [null_resource.cloud_provider_kind_clone]
}

# Push the image to a registry
resource "docker_registry_image" "pushed_image" {
  name = docker_image.cloud_provider_kind_build.name
}

# Start a container
resource "docker_container" "cloud_provider_kind_start" {
  name    = "cloud-provider-kind"
  image   = docker_image.cloud_provider_kind_build.image_id
  command = ["--enable-lb-port-mapping"]
  mounts {
    source = "/var/run/docker.sock"
    target = "/var/run/docker.sock"
    type   = "bind"
  }
  network_mode = "kind"
}

# Nginx stream proxy container for port forwarding
resource "docker_image" "nginx_stream" {
  name = "nginx:alpine"
}

resource "docker_container" "nginx_port_forward" {
  name  = "nginx-port-forward-443"
  image = docker_image.nginx_stream.image_id
  
  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }
  
  upload {
    content = <<-EOT
      events {
          worker_connections 1024;
      }
      
      stream {
          server {
              listen 443;
              proxy_pass 172.19.0.7:443;
          }
      }
    EOT
    file    = "/etc/nginx/nginx.conf"
  }
  
  command      = ["nginx", "-g", "daemon off;"]
  network_mode = "kind"
  restart      = "unless-stopped"
  
  depends_on = [docker_container.cloud_provider_kind_start]
}