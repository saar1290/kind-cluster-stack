output "harbor_url" {
  value = module.kind-cluster-stack.harbor_url
}

output "vault_url" {
  value = module.kind-cluster-stack.vault_url
}

output "argocd_url" {
  value = module.kind-cluster-stack.argocd_url
}

output "harbor_admin_password" {
  value = module.kind-cluster-stack.harbor_admin_password
}