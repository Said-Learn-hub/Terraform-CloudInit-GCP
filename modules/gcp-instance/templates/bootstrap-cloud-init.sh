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

  systemctl enable cloud-init-local.service cloud-init.service cloud-config.service cloud-final.service

  # Execute le pipeline complet immediatement (pas besoin de reboot)
  cloud-init init --local
  cloud-init init
  cloud-init modules --mode=config
  cloud-init modules --mode=final
fi
