resource "google_compute_instance" "vm" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = "default"
    access_config {} # Attribue une IP publique
  }

  metadata = {
    # Bootstrap execute une seule fois : installe cloud-init (absent de
    # l'image de base) puis le declenche pour qu'il lise "user-data".
    startup-script = file("${path.module}/templates/bootstrap-cloud-init.sh")

    # Configuration declarative habituelle, traitee par cloud-init une
    # fois que le bootstrap ci-dessus l'a installe.
    user-data = templatefile("${path.module}/templates/cloud-init.tpl", {
      hostname         = var.hostname
      timezone         = var.timezone
      keyboard_layout  = var.keyboard_layout
      keyboard_variant = var.keyboard_variant
      admin_user       = var.admin_user
      admin_password   = var.admin_password
      
      ssh_public_key   = var.ssh_public_key
      ssh_private_key   = var.ssh_private_key
      
      ansible_user       = var.ansible_user
      ansible_password   = var.ansible_password

      github_ssh_public_key   = var.github_ssh_public_key
      github_ssh_private_key   = var.github_ssh_private_key
    })
  }
}
