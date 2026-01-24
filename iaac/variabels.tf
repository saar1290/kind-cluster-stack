variable "ca_common_name" {
  description = "The common name for the CA certificate"
  type = string
}

variable "organization" {
  description = "The organization for the CA certificate"
  type = string
}

variable "country" {
  description = "The country for the CA certificate"
  type = string
}

variable "province" {
  description = "The province for the CA certificate"
  type = string
}

variable "locality" {
  description = "The locality for the CA certificate"
  type = string
}

variable "domain" {
  description = "The domain for the CA certificate"
  type = string
}

variable "cert_manager_version" {
  description = "The cert-manager chart version"
  type = string
}

variable "vault_version" {
  description = "The Vault chart version"
  type = string
}

variable "vault_hostname" {
  description = "The Vault hostname"
  type = string
}

variable "harbor_version" {
  description = "The Harbor installer version"
  type = string
}

variable "harbor_hostname" {
  description = "The Harbor hostname"
  type = string
}

variable "harbor_project" {
  description = "The Harbor project name"
  type = string
}

variable "cluster_name" {
  description = "The name of the kind cluster"
  type        = string
}

variable "node_image" {
  description = "The node image for the kind cluster"
  type        = string
}

variable "argocd_version" {
  description = "The ArgoCD chart version"
  type = string
}

variable "argocd_hostname" {
  description = "The ArgoCD hostname"
  type = string
}