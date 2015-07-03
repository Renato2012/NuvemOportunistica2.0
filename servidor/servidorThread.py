#!/usr/bin/python
#coding=UTF-8
import socket
import thread
import sys
from tomadecisoes import*
import errno

HOST = ''              # Endereco IP do Servidor
PORTA = 3000           # Porta que o Servidor esta respondendo

def conectado(con, cliente):
    print '\n Conectado ao: ', cliente

    try:
        while True:
            msgRecebida = con.recv(1024)
            if not msgRecebida: break
            print '\n', cliente, msgRecebida

        # ver qual a mensagem recebida do cliente
            print "a msg recebida é ", msgRecebida
            status = estado(cliente, msgRecebida)
            con.send(str(status))   

    except IOError as e:
        print(e)
        if e.errno != errno.ECONNRESET:
            raise
        pass            

    print '\n\t Finalizando conexao do cliente ', cliente
    con.close()
    thread.exit()

tcp = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

orig = (HOST, PORTA)

tcp.bind(orig) 	 # Adiciona IP e porta na conexão.
tcp.listen(100)	 # Na esculta, Quantidade Máx de clientes.  

print '\t\t Servidor em execução na porta '+ str(PORTA) +'\n'

# chama função que ativa script para verificar recurso da nuvem, passando o nome da Thread e o tempo para nove verificação.
thread.start_new_thread(verLog, ("Thread-1", 30, ))

while True:
    con, cliente = tcp.accept()
    thread.start_new_thread(conectado, tuple([con, cliente]))

tcp.close()
