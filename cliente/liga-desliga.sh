#!/bin/bash
# Renato
# 01/10/2014
# Liga, desliga e reinicia máquinas da rede remotamente.
# Usuário oneadmin, executa sudo sem senha nas máquinas da nuvem.

function ligar () {
    inicio=0
    qtd_hosts=$1
    for mac in $(cat ~/cliente/listaDeMACs.txt)
    do
        if [ $inicio -lt $qtd_hosts ] &> /dev/null; then
            echo -e "Pacote enviado para o MAC:\t $mac \n"
            wakeonlan $mac &> /dev/null
            inicio=$(expr $inicio + 1)
        fi   
    done
}
# Chamar remotamente o desliga.sh
function desligar () {
    usr_remoto=$USER	#usr_remoto oneadmin. 
    echo -e "\n"
    read -p "Desligar todas as máquinas? [s/n] " resposta
    
    if [ "$resposta" == s ]; then
        for ip in $(cat listaDeIPs.txt)
        do
            ssh $usr_remoto@$ip "sudo shutdown -h now" &> /dev/null
            echo -e "Desligando Host $ip \n"
        done
    elif [ "$resposta" == n ]; then
        read -p "Digite o IP: " ip
        ssh $usr_remoto@$ip "sudo shutdown -h now" &> /dev/null
        echo -e "Desligando Host $ip \n"
    else
       echo "Digite s ou n!"
       exit 0
    fi
}

function reiniciar() { 
    usr_remoto=$USER
    read -p "Digite o IP: " ip
    ssh $usr_remoto@$ip "sudo reboot" &> /dev/null 
    echo -e "Reiniciando Host $ip \n"
}

function ajuda() {
    ajuda="Uso: 
           Para ligar:		$0 l qtd_host
           Para desligar:	$0 d
           para reiniciar:	$0 r"
    echo "$ajuda"
}

opcao=$1
qtd_hosts=$2

case $opcao in
l) ligar $qtd_hosts ;;
d) desligar ;;
r) reiniciar ;;
*) ajuda ;;
esac
