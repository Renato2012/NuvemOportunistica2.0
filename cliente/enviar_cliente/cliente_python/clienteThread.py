#!/usr/bin/python
#coding=UTF-8
import os
import socket
import time		# Importar modulo time para usar o relogio.
from monitora import*	# Importar modulo da função monitoramento. 

#recebe os parametros digitados
ip = "200.129.39.81"
porta = int(3000)
servidor = "maquina1"

# Verificar se tem rede.
var = 1
while var != 0:
    var = os.system("ping -c1 " + ip)
    time.sleep (1) 
# fim do laço

tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
destino = (ip, porta)
tcp.connect(destino)

# Chama função para montar NFS.
montar_nfs(ip, servidor)

def estado():
    status = on_off()		# chama função, que verifica status.
    if int(status) == 0:
        #print "enviando start"
        tcp.send("start")

        while True:
            time.sleep (1)
            #print "dentro do laço"
            status = on_off()
            if int(status) != 0:	# achou a palavra stop no arquivo
                #print "enviando stop"
                tcp.send("stop")
                resposta = tcp.recv(1024)
                print "a resposta foi " + resposta
                tcp.close()
                break

# chama a função estado
estado()

#fecha a conexao
tcp.close()

