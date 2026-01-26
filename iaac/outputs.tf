output "harbor_url" {
  value = "https://${var.harbor_hostname}"
}

output "vault_url" {
  value = "https://${var.vault_hostname}"
}

output "argocd_url" {
  value = "https://${var.argocd_hostname}"
}

output "harbor_admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}