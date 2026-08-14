variable "project_id" {
  type    = string
  default = "tp-vde-gcp-devops-504507"
}
variable "region" { default = "europe-west1" }
variable "zone"   { default = "europe-west1-b" }
variable "env"    { default = "dev" }

variable "ssh_public_key" {
  default   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEnV6lRsJCg/cf1XZarkA5/gnhQn59QrwoNGLdgDHCZG deployer"
  description = "Contenu de votre clé publique SSH  générée sur votre machine Windows"
  type        = string
}

variable "admin_password" {
  default = "Said4321"
  description = "Mot de passe de l'utilisateur créé sur la VM, pour la connexion SSH par mot de passe"
  type        = string
  sensitive   = false
}
