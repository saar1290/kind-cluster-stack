module "kind-cluster-stack" {
  source               = "./iaac"
  sudo                 = var.sudo
  domain               = "saar-lab.local"
  ca_common_name       = "kind-cluster-ca"
  organization         = "Saar Lab"
  organizational_unit  = "DevOps"
  country              = "IL"
  province             = "Haifa"
  locality             = "Israel"
  harbor_version       = "v2.14.2"
  harbor_hostname      = "harbor.saar-lab.local"
  harbor_project       = "eco-system"
  cluster_name         = "saar-lab"
  node_image           = "kindest/node:v1.35.0"
  cert_manager_version = "v1.19.2"
  vault_version        = "0.32.0"
  vault_hostname       = "vault.saar-lab.local"
  argocd_version       = "9.3.5"
  argocd_hostname      = "argocd.saar-lab.local"
  remote_repositories = [
    {
      provider     = "docker-hub"
      endpoint     = "https://hub.docker.com"
      project_name = "eco-system"
    },
    {
      provider     = "quay-io"
      endpoint     = "https://quay.io"
      project_name = "eco-system"
    }
  ]
}