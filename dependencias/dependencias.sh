#!/bin/bash

# Renato
# 21/08/2014
# Pacotes a serem instalados no Servidor.
echo -e "\n\t\t\t Aguarde as instalações! \n"

# Instala o pacote wakeonlan, para ativar os hosts da rede.
apt-get -y install wakeonlan

# Instala o sshpass, para passar a senha junto do comando ssh.
apt-get -y install sshpass

# Instalar pacote para habilitar ativação remota
apt-get -y install ethtool

# Ativar ativação remota
sudo ethtoll -s br0 wol g

##----NFS SERVER-----
# Instalar o nfs-server
sudo apt-get -y install nfs-kernel-server

# Configurar pasta para ser exportada



# Chamar os Scripts na ordem de execução no servidor.
## Ligue todas as máquinas da sua rede que você deseja que pertença a nuvem, o Script seguinte irá pegar todos os MACs e IPs ativos da sua rede.
./procuraMACS.sh 
