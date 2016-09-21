#!/usr/bin/python
#coding=UTF-8

# Renato Cavalcante
# 24/08/2015

# A Máquina Física(MF) será desligada automaticamente se não houver usuário logado e Máquina Virtual(MV) em execução. Mas deve haver uma tolerância, pois no momento inicial em que a MF estiver ligando não haverá usuário logado e nem MV, o que causaria o desligamento da MF imediatamente ao ligar. Portanto deve haver uma espera inicial, para de fato haver as verificações por usuário e MV.

import os
import commands
import time

def desligar(tempo_logar):
    cont = 0
    #tempo_logar = 300
    # 300s são 5 primeiros minutos, que a MF poderá ficar ligada sem MV em execução e sem usuário logado sem que haja o desligamento da MF.	

    for i in range(cont, tempo_logar):
        print "iteração ", i
        time.sleep (1)

    # Início da verificação por MV runn e usuário logado.
    while True:
        mv = commands.getoutput("pgrep kvm | wc -l")	# Se retornar maior que 1, tem MV em execução.
        usuario = commands.getoutput("who -q | sed -n 's/^.*=//p'")	# Quantidade de usuários logados, se retornar 0, não tem usuário logado.
     
        if (int(mv) <= 1 and int(usuario) == 0):
            os.system("shutdown -h now")
            break
        time.sleep (1)


# chamar função
#desligar()
