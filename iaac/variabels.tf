locals {
  docker_certs_dir     = pathexpand("~/.docker/certs.d/${var.harbor_hostname}:443")
  harbor_data_location = pathexpand("~/harbor")
}

variable "sudo" {
  description = "Sudo command prefix for scripts that require elevated permissions"
  type        = string
}

variable "ca_common_name" {
  description = "The common name for the CA certificate"
  type        = string
}

variable "organization" {
  description = "The organization for the CA certificate"
  type        = string
}

variable "organizational_unit" {
  description = "The organizational unit for the CA certificate"
  type        = string
}

variable "country" {
  description = "The country for the CA certificate"
  type        = string
}

variable "province" {
  description = "The province for the CA certificate"
  type        = string
}

variable "locality" {
  description = "The locality for the CA certificate"
  type        = string
}

variable "domain" {
  description = "The domain for the CA certificate"
  type        = string
}

variable "cert_manager_version" {
  description = "The cert-manager chart version"
  type        = string
}

variable "vault_version" {
  description = "The Vault chart version"
  type        = string
}

variable "vault_hostname" {
  description = "The Vault hostname"
  type        = string
}

variable "harbor_version" {
  description = "The Harbor installer version"
  type        = string
}

variable "harbor_hostname" {
  description = "The Harbor hostname"
  type        = string
}

variable "harbor_projects" {
  description = "The Harbor projects name"
  type        = list(string)
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
  type        = string
}

variable "argocd_hostname" {
  description = "The ArgoCD hostname"
  type        = string
}

variable "remote_repositories" {
  description = "List of remote git repositories to sync with ArgoCD"
  type = list(object({
    provider     = string
    endpoint     = string
    project_name = string
  }))
  default = []
}