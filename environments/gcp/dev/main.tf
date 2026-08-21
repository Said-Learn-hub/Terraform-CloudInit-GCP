module "gcp_instance" {
  source = "../../../modules/gcp-instance"

  instance_name = "vm-${var.env}"
  zone          = var.zone

  hostname         = "Said"
  timezone         = "Europe/Paris"
  keyboard_layout  = "fr"
  keyboard_variant = "azerty"

  admin_user     = "deployer"
  admin_password = var.admin_password
  ssh_public_key = var.ssh_public_key
  ssh_private_key   = var.ssh_private_key

  ansible_user     = "ansible"
  ansible_password = var.ansible_password
  github_ssh_public_key = var.github_ssh_public_key
  github_ssh_private_key = var.github_ssh_private_key

}
