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
}
