#!/bin/bash
# Bootstrap : installe cloud-init s'il n'est pas deja present, puis
# declenche manuellement le pipeline cloud-init pour qu'il traite le
# user-data (cloud-config) fourni via les metadonnees de l'instance.
set -e

if ! command -v cloud-init &> /dev/null; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y cloud-init

  mkdir -p /etc/cloud/cloud.cfg.d
  cat <<'EOC' > /etc/cloud/cloud.cfg.d/99_gce_datasource.cfg
datasource_list: [ GCE ]
EOC

  # L'image Debian de base ne liste pas le module "ansible" dans
  # cloud_final_modules par defaut -- sans ce fragment, cc_ansible
  # (et donc ansible-pull) ne se declenche jamais, meme si "ansible:"
  # est bien present dans le user-data.
  #
  # IMPORTANT: cloud-init REMPLACE la liste cloud_final_modules lors de
  # la fusion des fichiers cloud.cfg.d/*.cfg (pas de merge/append). On
  # doit donc redeclarer la liste complete par defaut (vue via
  # `cat /etc/cloud/cloud.cfg`), avec "ansible" insere APRES
  # "scripts-user" -- c'est ce module qui execute le runcmd (ssh-keyscan
  # pour known_hosts), et "write-files-deferred" (deja present, plus tot
  # dans la liste) qui ecrit les cles privees via "defer: true". Sans cet
  # ordre, ansible-pull s'execute avant que les cles/known_hosts existent.
  cat <<'EOC' > /etc/cloud/cloud.cfg.d/99_enable_ansible_module.cfg
cloud_final_modules:
  - package-update-upgrade-install
  - fan
  - landscape
  - lxd
  - write-files-deferred
  - puppet
  - chef
  - mcollective
  - salt-minion
  - reset_rmc
  - scripts-vendor
  - scripts-per-once
  - scripts-per-boot
  - scripts-per-instance
  - scripts-user
  - ansible
  - ssh-authkey-fingerprints
  - keys-to-console
  - install-hotplug
  - phone-home
  - final-message
  - power-state-change
EOC

  # Note: sur les versions recentes de cloud-init (>= ~24.x, ex. Debian 13),
  # l'unite systemd s'appelle cloud-init-main.service, plus cloud-init.service.
  systemctl enable cloud-init-local.service cloud-init-main.service cloud-config.service cloud-final.service

  # Execute le pipeline complet immediatement (pas besoin de reboot)
  cloud-init init --local
  cloud-init init
  cloud-init modules --mode=config
  cloud-init modules --mode=final
fi