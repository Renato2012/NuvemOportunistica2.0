#!/usr/bin/python
#coding=UTF-8
import os
import commands

# Renato
# 06/08/2014

# monta nfs ao ligar o sistema.
def montar_nfs(ip_servidor, servidor):
    result = os.system("ping -c2 " + ip_servidor)
    if result == 0:
        os.system("mount -t nfs " + servidor +":/srv/cloud/one/var/datastores/ /srv/cloud/one/var/datastores/;")

# ler arquivo de log do daemon-cliente, ver se está start ou stop.
def on_off ():
    estado = os.system("grep start /var/log/daemon-cliente.log")
    return estado
