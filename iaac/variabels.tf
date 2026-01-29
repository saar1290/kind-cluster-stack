locals {
  ssl_certs_dir        = pathexpand("~/kind-stack/certs")
  docker_certs_dir     = pathexpand("~/.docker/certs.d/${var.harbor_hostname}:443")
  harbor_data_location = pathexpand("~/harbor-data")
  harbor_installation_dir = pathexpand("~/harbor")
  cloud_provider_kind_dir = pathexpand("~/cloud-provider-kind")
  default_admin_password = "Harbor12345"
}

variable "sudo" {
  description = "Sudo password for executing commands with elevated privileges"
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

variable "nodes" {
  description = "List of nodes for the kind cluster"
  type = list(object({
    role = string
    image = optional(string)
    kubeadm_config_patches = optional(list(string))
    labels = optional(map(string))
    extra_mounts = list(object({
      host_path      = optional(string)
      container_path = optional(string)
      read_only      = optional(bool)
      propagation    = optional(string)
      selinux_relabel = optional(bool)
    }))
    extra_port_mappings = list(object({
      container_port = optional(number)
      host_port      = optional(number)
      protocol       = optional(string)
      listen_address = optional(string)
    }))
  }))
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

variable "kind_control_plane_int_port" {
  description = "The internal port for the kind control plane"
  type        = number
  default     = 443
}

variable "kind_control_plane_ext_port" {
  description = "The external port for the kind control plane"
  type        = number
  default     = 443
}

variable "kind_control_plane_protocol" {
  description = "The protocol for the kind control plane"
  type        = string
  default     = "tcp"
}

variable "kind_control_plane_ip" {
  description = "The IP address for the kind control plane"
  type        = string
}
