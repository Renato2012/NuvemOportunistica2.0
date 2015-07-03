#!/bin/bash
# Renato
# 20/10/2014

# startar opennebula e o sunstone server, respectivamente.
one start 2> /dev/null
sunstone-server start 2> /dev/null

# Criar cluster para adicionar as máquinas clientes.
if onecluster list | grep cluster 
then
    echo "cluster já criado"; 
else
    onecluster create cluster1
fi

# Adicionar host remoto a nuvem, basta executar apenas uma vez para cada host.
for cliente in $(grep maquina /etc/hosts | cut -d m -f2 | sed -e 's/a/ma/')
do
    if ! onehost list | grep -w $cliente &> /dev/null; then
        onehost create $cliente -i kvm -v kvm -n dummy
# Adicionar cada host ao cluster
        onecluster addhost cluster1 $cliente
    fi
done

# verifica log do opennebula para ver se precisa alocar nova MF.
#qtd=0
#while :
#do
#    if tail /srv/cloud/one/var/sched.log | grep 'Not enough capacity'; then
#        qtd=$(($qtd+1))
#        cd ~/cliente && ./liga-desliga.sh l $qtd
#        sleep 30
#    fi
#done

# Comando pra migrar vm
#onevm migrate 42 10     #(42-id vm, 10 id-maquina )
