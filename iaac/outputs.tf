output "harbor_url" {
  value = "https://${var.harbor_hostname}:${var.harbor_port}"
}

output "vault_url" {
  value = "https://${var.vault_hostname}"
}

output "argocd_url" {
  value = "https://${var.argocd_hostname}"
}

output "harbor_admin_password" {
  value = nonsensitive(random_password.admin_password.result)
}