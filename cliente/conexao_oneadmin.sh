#!/bin/bash
# Renato
# 02/10/2014 
# OBS: execute como oneadmin

# =========== Configurar conexão sem senha =============
# Testa se o diretorio .ssh existe e está vazio, se verdadeiro entra no mesmo e gera a chave assimetrica de forma a não solicitar a confirmação através do yes ''. Copia a chave publica para o arquivo authorized_keys.
# Se não se, verifica se o diretório existe e tem conteúdo.
# Se não existir, cria o diretório .ssh, entra no mesmo e gera o par de chaves.

# Script deve ser movido para /home/oneadmin e executado com o usuário oneadmin
if [ $USER != "oneadmin" ]; then
    echo "Script deve pertencer ao usuário oneadmin
          e está no diretório /home/oneadmin para ser executado!";
    exit 0 
fi

# Inserir IP local apenas 1 vez, na lista de enviados para evitar tranferir e instalar os pacotes no servidor.
ip_servidor=$(ifconfig br0 | sed -rn '/([0-9]+\.){3}[0-9]+/p' | sed 's/^.*end.: //' | sed 's/ [Bcast-Masc].*$//')
if ! grep $ip_servidor ListaIPsEnviados.txt &> /dev/null; then
    echo $ip_servidor >> ListaIPsEnviados.txt
fi

# ============ Local =================
user=$USER
path=/home/$user/.ssh
if [ -e $path ]; then
    echo "Diretório .ssh já criado"
else
    mkdir $path
    cd $path
    yes "" | ssh-keygen -t rsa -b 2048 -N ""
    cat $path/id_rsa.pub >> $path/authorized_keys
    echo "Diretório criado com Sucesso"

# Desabilita checagem de hosts ao acesso remoto.
    echo "Host *" > $path/config
    echo "    StrictHostKeyChecking no" >> $path/config
    echo "    UserKnownHostsFile /dev/null" >> $path/config
    chmod 600 $path/config

# Copia o diretório .ssh para o diretório a ser enviado aos clientes.
    cp -R ~/.ssh ~/cliente/enviar_cliente/
fi

# =========== Remoto ================
# Função ler uma lista com os IPs dos clientes e envia a chave publica para cada host da rede.
function instalar() {
    adm_remoto=$1
    adm_senha=$2
    maquina_servidor=$(hostname)

    incrementa=1
    for ip in $(cat listaDeIPs.txt);
    do
        if grep $ip ListaIPsEnviados.txt &> /dev/null; then
            echo -e "Host $ip - já configurado anteriormente!\n"

# Gerar par de chave no host remoto, e enviar chave pública do servidor local.
        elif arping -c2 -I br0 $ip &> /dev/null; then 
            echo -e "\tHost: $ip alcançado. Transferindo arquivos.\n"
            incrementa=$(expr $incrementa + 1)
            nome_maquina="maquina$incrementa"

# Transferir arquivos para os hosts alcançados na rede.
            sshpass -p $adm_senha scp -r enviar_cliente $adm_remoto@$ip:/home/$adm_remoto/
	    sshpass -p $adm_senha ssh $adm_remoto@$ip "cd ~/enviar_cliente && ./instal_cliente.sh $adm_senha $nome_maquina $ip $ip_servidor $maquina_servidor" 

# Nesse momento o usuário oneadmin já está criado na máquina remota.        
# Escrever no arquivo /etc/hosts o IP e o Hostname de cada máquina configurada.
# Usuário oneadmin pode executar sudo sem senha.
# /^$/ representa linha em branco, i\ insere texto anterior, \t tabulação.
            cat /etc/hosts | grep -w $nome_maquina &> /dev/null
            if [ $? != 0 ]; then
                sudo sed -i '/^$/i\'"$ip"'\t'"$nome_maquina"'' /etc/hosts
            fi
# Copia o IP/nome para a lista de IPs já enviados.
            echo -e "$ip \t$nome_maquina" >> ListaIPsEnviados.txt

        else
            echo -e "Host: $ip não alcançado.\n"    
        fi
    done
}

function adicionar() {
    adm_remoto=$1
    adm_senha=$2
    maquina_servidor=$(hostname)

    host_remoto=$(cat /etc/hosts | grep maquina | wc -l)	# quantidade de hosts no /etc/hosts

    read -p "Digite a quantidade de máquina para adicionar: " num_maquina
    qtd_maquina=$(($num_maquina + $host_remoto))

    for prox_host in $(seq $((host_remoto+1)) $qtd_maquina)
    do
        read -p "Digite o endereço IP do cliente: " ip_remoto

        if grep $ip_remoto ListaIPsEnviados.txt &> /dev/null; then
            echo -e "Host $ip_remoto - já configurado anteriormente!\n"
    
# Gerar par de chave no host remoto, e enviar chave pública do servidor local.
        elif arping -c2 -I br0 $ip_remoto &> /dev/null; then
            echo -e "\tHost: $ip_remoto alcançado. Transferindo arquivos.\n"
            nome_maquina="maquina$prox_host"

# Transferir arquivos para os hosts alcançados na rede.
            sshpass -p $adm_senha scp -r enviar_cliente $adm_remoto@$ip_remoto:/home/$adm_remoto/
            sshpass -p $adm_senha ssh $adm_remoto@$ip_remoto "cd ~/enviar_cliente && ./instal_cliente.sh $adm_senha $nome_maquina $ip_remoto $ip_servidor $maquina_servidor"

# Se IP não tiver na lista de IPs, o insere.
            if ! grep -w $ip_remoto listaDeIPs.txt &> /dev/null; then
                echo "$ip_remoto" >> listaDeIPs.txt
            fi

# Se cliente não tiver no /etc/hosts do servidor, insere.
            if ! grep -w $nome_maquina /etc/hosts &> /dev/null; then
                sudo sed -i '/^$/i\'"$ip_remoto"'\t'"$nome_maquina"'' /etc/hosts
            fi
# Copia o IP/nome para a lista de IPs já enviados.
            echo -e "$ip_remoto \t$nome_maquina" >> ListaIPsEnviados.txt

        else
            echo -e "Host: $ip_remoto não alcançado.\n"    
        fi
    done
}

#======= Função que transfere o arquivo /etc/hosts do servidor para os clientes ========
function transfere() {
    echo -e "\n\t Aguarde! Transferindo /etc/hosts aos clientes.\n"
    usr_remoto=$USER	# usr_remoto oneadmin.
    for ip in $(cat listaDeIPs.txt)
    do
        scp /etc/hosts $usr_remoto@$ip:~ 
        ssh $usr_remoto@$ip "sudo cp /etc/hosts /etc/hosts.old && sudo mv ~/hosts /etc/"
    done
}

#================ Função mostra informações de uso. =================
function uso() {
    echo "uso:       
                para instalar a 1ª vez: $0 i
                para adicionar nova máquina: $0 a"
}
#============================= Menu =================================
if [ $# = 0 ]; then
    uso 	# chama a função uso e sai.    
    exit 0
fi

read -p "Digite o login do administrador remoto: " adm_remoto
read -s -p "Digite a senha de administrador remoto: " adm_senha
echo -e "\n"

opcao=$1
case $opcao in
i) instalar $adm_remoto $adm_senha
   transfere	# chama a função transfere, após configurar todos os clientes.
;;
a) adicionar $adm_remoto $adm_senha
   transfere	# chama a função transfere, após adicionar uma nova máquina cliente.
;;
*) uso
;;

esac

exit 0
