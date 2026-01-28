resource "null_resource" "names" {
  triggers = {
    harbor_hostname = var.harbor_hostname
    sudo           = var.sudo
  }
  provisioner "local-exec" {
    command = "scripts/set-hostnames.sh ${self.triggers.harbor_hostname} ${self.triggers.sudo}"
  }
  provisioner "local-exec" {
    when = destroy
    command = "scripts/clear-hostnames.sh ${self.triggers.harbor_hostname} ${self.triggers.sudo}"
  }
  depends_on = [ null_resource.write_ca_files ]
}