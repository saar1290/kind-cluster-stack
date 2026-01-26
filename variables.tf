variable "sudo" {
  description = "Sudo command prefix for scripts that require elevated permissions"
  type        = string
  sensitive = true
}
