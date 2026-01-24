terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 3.6"
    }
    kind = {
      source = "tehcyx/kind"
      version = "~> 0.10"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 3.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.1"
    }
  }
}

# Configure the Kind Provider
provider "kind" {}

# Configure the Docker Provider
provider "docker" {}

# Configure the TLS Provider
provider "tls" {}

# Configure the Helm Provider
provider "helm" {
 kubernetes = {
    host                   = kind_cluster.default.kubeconfig[0].host
    client_certificate     = base64decode(kind_cluster.default.kubeconfig[0].client_certificate)
    client_key             = base64decode(kind_cluster.default.kubeconfig[0].client_key)
    cluster_ca_certificate = base64decode(kind_cluster.default.kubeconfig[0].cluster_ca_certificate)
  }
}

# Configure the Kubernetes Provider
provider "kubernetes" {
  host                   = kind_cluster.default.kubeconfig[0].host
  client_certificate     = base64decode(kind_cluster.default.kubeconfig[0].client_certificate)
  client_key             = base64decode(kind_cluster.default.kubeconfig[0].client_key)
  cluster_ca_certificate = base64decode(kind_cluster.default.kubeconfig[0].cluster_ca_certificate)
}