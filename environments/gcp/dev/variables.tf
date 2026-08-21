variable "project_id" {
  type    = string
  default = "tp-vde-gcp-devops-504507"
}
variable "region" { default = "europe-west1" }
variable "zone"   { default = "europe-west1-b" }
variable "env"    { default = "dev" }

variable "ssh_public_key" {
  description = "Contenu de votre clé publique SSH  générée sur votre machine Windows"
  type        = string
}

variable "ssh_private_key" {
  description = "Contenu de votre clé prive SSH  générée sur votre machine Windows"
  type        = string
}

variable "github_ssh_public_key" {
  description = "Contenu de votre clé publique SSH  générée sur votre machine Windows"
  type        = string
}

variable "github_ssh_private_key" {
  description = "Contenu de votre clé publique SSH  générée sur votre machine Windows"
  type        = string
}

variable "admin_password" {
  default = ""
  description = "Mot de passe de l'utilisateur créé sur la VM, pour la connexion SSH par mot de passe"
  type        = string
  sensitive   = false
}

variable "ansible_password" {
  default = ""
  description = "Mot de passe de l'utilisateur créé sur la VM, pour la connexion SSH par mot de passe"
  type        = string
  sensitive   = false
}
