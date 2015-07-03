#!/bin/bash
# Renato 
# 08/10/2014

# Instalador dos clientes, que irá ser transferido e executado remotamente.
senha=$1
nome_maquina=$2
ip=$3
ip_servidor=$4
maquina_servidor=$5

# Chama o script instal_kvm.sh passando os parametros.
./conf_cliente.sh $senha $nome_maquina $ip $ip_servidor $maquina_servidor

# Configurar clienteThread.py com ip do servidor.
sed -i 's/ip = "200.129.39.81"/ip = "'$ip_servidor'"/' cliente_python/clienteThread.py

# Colocar os scripts .py no diretório /usr/sbin/ para ficar na inicialização do Ubuntu.
echo $senha | sudo -S cp -R cliente_python/ /usr/sbin/
echo $senha | sudo -S cp daemon-cliente.sh /etc/init.d/
echo $senha | sudo -S update-rc.d daemon-cliente.sh defaults  

#%%%%%%% Reiniciar cliente após as configurações.
#echo $senha | sudo -S shutdown -r -h 1
