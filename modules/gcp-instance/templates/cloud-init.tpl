#cloud-config
hostname: ${hostname}
timezone: ${timezone}

ssh_pwauth: true

# "git" est requis par le module ansible (ansible-pull clone via git) mais
# n'est pas present sur l'image Debian de base -- sans ça, cc_ansible
# echoue silencieusement avec "Failed to find required executable git".
packages:
  - git

users:
  - name: ${admin_user}
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: '${admin_password}'
    homedir: /home/${admin_user}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
%{ if ssh_public_key != "" ~}
    ssh_authorized_keys:
      - ${ssh_public_key}
%{ endif ~}

  - name: ${ansible_user}
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: '${ansible_password}'
    homedir: /home/${ansible_user}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
%{ if github_ssh_public_key != "" ~}
    ssh_authorized_keys:
      - ${github_ssh_public_key}
%{ endif ~}

write_files:
  # Clé privée de l'utilisateur deployer.
  - path: /home/${admin_user}/.ssh/id_ed25519
    owner: ${admin_user}:${admin_user}
    permissions: '0600'
    defer: true
    content: |
      ${indent(6, ssh_private_key)}

  # Clé privée GitHub pour le module Ansible
  - path: /home/${ansible_user}/.ssh/id_ed25519
    owner: ${ansible_user}:${ansible_user}
    permissions: '0600'
    defer: true
    content: |
      ${indent(6, github_ssh_private_key)}

  # Configuration SSH pour GitHub (évite d'utiliser ssh-keyscan dans runcmd)
  - path: /home/${ansible_user}/.ssh/config
    owner: ${ansible_user}:${ansible_user}
    permissions: '0600'
    defer: true
    content: |
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519
        StrictHostKeyChecking accept-new

# Execution du pull Ansible par cloud-init
ansible:
  package_name: ansible
  install_method: distro
  run_user: ${ansible_user}
  pull:
    url: git@github.com:Said-Learn-hub/Terraform_Cloudinit_Ansible_GCP.git
    playbook_name: playbook.yml