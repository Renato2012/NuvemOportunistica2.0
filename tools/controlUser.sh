#!/bin/bash
# 
# Renato
#
# OBS.: Script NÃO usado na solução!
#
# ========== Controle de usuário permissão de root =================
# Executar uma vez em cada máquina.
#
# Script configura o arquivo /etc/sudoers, para o user executar os comandos shutdown, reboot e halt como sudo, sem precisar digitar a senha de root. 
# esse comando adiciona uma linha após a palavra env
# sed -i '/env/{p;s/.*/palavra adicionada/;}' arquivo
# insere palavra no final do arquivo
# sed -i -e '\' -e 'palavra' arquivo
# sed -e '5i\' -e 'palavra antes da linha 5' arquivo

echo "Digite a senha de administrador "
read -s senha

echo $senha | sudo -S sed -i '/env_reset/{p;s/.*/Cmnd_Alias TESTE_SHUTDOWN = \/sbin\/shutdown, \/sbin\/halt, \/sbin\/reboot/;}' /etc/sudoers
  
echo $senha | sudo -S sed -i -e '$a\' -e 'oneadmin ALL=(ALL) NOPASSWD: TESTE_SHUTDOWN' /etc/sudoers


