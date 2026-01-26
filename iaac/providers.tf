terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
    harbor = {
      source  = "goharbor/harbor"
      version = "~> 3.11"
    }
  }
}

# Configure the Harbor Provider
provider "harbor" {
  url      = "https://${var.harbor_hostname}"
  username = "admin"
  password = random_password.admin_password.result
  insecure = true
}

# Configure the Docker Provider
provider "docker" {
  host = "unix:///var/run/docker.sock"
  registry_auth {
    address  = var.harbor_hostname
    username = "admin"
    password = random_password.admin_password.result
  }
}

# Configure the Helm Provider
provider "helm" {
  kubernetes = {
    host                   = kind_cluster.default.endpoint
    client_certificate     = kind_cluster.default.client_certificate
    client_key             = kind_cluster.default.client_key
    cluster_ca_certificate = kind_cluster.default.cluster_ca_certificate
  }
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host                   = kind_cluster.default.endpoint
  client_certificate     = kind_cluster.default.client_certificate
  client_key             = kind_cluster.default.client_key
  cluster_ca_certificate = kind_cluster.default.cluster_ca_certificate
}

# Configure the kubectl Provider
provider "kubectl" {
  host                   = kind_cluster.default.endpoint
  client_certificate     = kind_cluster.default.client_certificate
  client_key             = kind_cluster.default.client_key
  cluster_ca_certificate = kind_cluster.default.cluster_ca_certificate
}