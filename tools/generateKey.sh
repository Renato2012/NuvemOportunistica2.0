#!/bin/bash
#
# Renato
#
# 19/08/2014
#
# OBS.: Script NÂO usado na solução! Isso já está implementado nos scripts do módulo cliente.
#
# Gerar chaves assimetricas do oneadmin
# Importante: script tem que pertencer ao oneadmin.

mkdir ~/.ssh
cd ~/.ssh
yes "" | ssh-keygen -t rsa -b 2048 -N ""
cat id_rsa.pub >> ~/.ssh/authorized_keys

# Desabilitar checagem de hosts ao acesso remoto.
cat << EOF > ~/.ssh/config
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
EOF
chmod 600 ~/.ssh/config


