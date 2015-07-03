#!/bin/bash
# Renato 
# 02/10/2014

# Para ver partes montadas: showmount -e
# Inclui o arquivo variaveis, gerado pelo script procuraMACs.sh, para ter acesso as variaveis de ambiente salvas nesse arquivo.
# $IP_LOCAL, $MASC_SUB_REDE, $IP_SUB_REDE
. variaveis   

read -s -p "Digite a senha de administrador: " adm_senha
echo -e "\n"

# Configurar a pasta a ser exportada.
# Insere palavra no final do arquivo /etc/exports.
echo $adm_senha | sudo -S sed -i -e '$a\' -e '/srv/cloud/one/var/datastores '"$IP_SUB_REDE"'/'"$MASC_SUB_REDE"'(rw,sync,no_root_squash,no_subtree_check) ' /etc/exports

echo $adm_senha | sudo -S service nfs-kernel-server restart

echo $adm_senha | sudo -S exportfs 

