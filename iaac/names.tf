resource "null_resource" "names" {
  triggers = {
    harbor_hostname = var.harbor_hostname
    argocd_hostname = var.argocd_hostname
    sudo            = var.sudo
  }
  provisioner "local-exec" {
    command = "scripts/set-hostnames.sh ${self.triggers.sudo} ${self.triggers.harbor_hostname} ${self.triggers.argocd_hostname}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "scripts/clear-hostnames.sh ${self.triggers.sudo} ${self.triggers.harbor_hostname} ${self.triggers.argocd_hostname}"
  }
  depends_on = [
    null_resource.write_harbor_certificates_files
  ]
  lifecycle {
    replace_triggered_by = [  
      null_resource.harbor_install
    ]
  }
}