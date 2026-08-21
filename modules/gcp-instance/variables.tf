variable "instance_name" { type = string }
variable "machine_type"  { default = "e2-micro" }
variable "zone"          { default = "europe-west1-b" }

# IMAGE DEBIAN 12 AVEC CLOUD-INIT INTÉGRÉ
variable "image" { default = "debian-cloud/debian-13" }

variable "hostname"         { default = "instance" }
variable "timezone"         { default = "Europe/Paris" }
variable "keyboard_layout"  { default = "fr" }
variable "keyboard_variant" { default = "azerty" }

variable "admin_user"     { default = "deployer" }
variable "admin_password" {
  default   = ""
  sensitive = true
}
variable "ssh_public_key" { default = "" }
variable "ssh_private_key" { default = "" }

#ansible user

variable "ansible_user"     { default = "ansible" }
variable "ansible_password" {
  default   = ""
  sensitive = true
}
variable "github_ssh_public_key" { default = "" }
variable "github_ssh_private_key" { default = "" }