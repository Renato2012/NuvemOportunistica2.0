#!/usr/bin/python
#coding=UTF-8
import os
import commands
import time

# Renato
# 07/08/2014
# O servidor chama essa função, para a verficação periodica do status dos clientes para a tomada de decisões.  

# verifica log, se tiver a mensagem Capacidade não é suficiente. Liga nova MF
def verLog(nomeThread, delay):
    os.system("cd ~/cliente && ./one.sh")
    qtd = 0
    print "Verificação de log iniciada em", nomeThread
    while True:
        result = os.system("tail /srv/cloud/one/var/sched.log | grep 'Not enough capacity'")
        if result == 0: 	# achou mensagem, chama scprit liga-desliga.sh
            qtd = qtd + 1	# passando a qtd de MFs.
            os.system("bash ~/cliente/liga-desliga.sh l "+ qtd)
        time.sleep (delay)	# espera 30 segundos e verifica outra vez.


# Função principal
def estado(cliente, msgRecebida):
    ip_cliente = cliente[0]
    nome_host = commands.getoutput("grep "+ ip_cliente +" /etc/hosts | sed -r 's/([[:digit:]]+\.){3}[0-9]+\t//'")
    id_host = commands.getoutput("onehost list | grep "+ nome_host +" | cut -d' ' -f3")

    if msgRecebida == "stop":
# Antes de desabilitar o host, ver se tem VMs, para migra-las para as MF fixas.
        result = commands.getoutput("onevm list -l STAT,HOST | grep "+ nome_host)
        if result.find('runn') == 0:		# tem VM em estado runn        
            print "VM status runn, Host: ", nome_host
# onehost flush desabilita o host e migra VMs para hosts com capacidade de recursos disponiveis.
            os.system("onehost flush "+ nome_host)
            return "disable"

        else:		# Não tem VM status runn, desabilita host da nuvem. 
            os.system("onehost disable "+ id_host)
            return "disable"

# Se msg não for stop, então é para habilitar o host remoto na nuvem.
    else:
        os.system("onehost enable "+ id_host)

