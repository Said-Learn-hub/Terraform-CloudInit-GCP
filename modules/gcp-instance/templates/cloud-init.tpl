#cloud-config
hostname: ${hostname}
fqdn: ${hostname}
timezone: ${timezone}

ssh_pwauth: true

users:
  - default
  - name: ${admin_user}
    groups: sudo
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: '${admin_password}'
    homedir: /home/${admin_user}
    create_home: true
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
%{ if ssh_public_key != "" ~}
    ssh_authorized_keys:
      - ${ssh_public_key}
%{ endif ~}

runcmd:
  - systemctl restart ssh
