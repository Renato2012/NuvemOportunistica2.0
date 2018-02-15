#!/bin/bash
#
# Renato Cavalcante
# 02/12/15
#
# Script de gravação do tempo gasto para ligar as MFs da nuvem.

# IFS (Internal Field Separator, separador do campo interno)
oldIFS=$IFS  # Backup do separador de campo.
IFS=$'\n'    # Novo separador de campo, o caractere fim de linha.

HORAINIC=$(date +%H:%M:%S)

echo -e "Máquinas \t | Hora inicial \t | Hora final" > exper_logs.txt

for LINHA in $(onehost list | grep on)
do
#    LINHA=$(onehost list | grep -E [a-z])
#    MFSTATUS=$(echo $LINHA | awk '{print $13}')

    MF=$(echo $LINHA | awk '{print $2}')
# Se MF não tiver no arquivo de logs, então a insere.        
    if ! grep $MF exper_logs.txt &> /dev/null; then
        echo "$MF status on"

        HORAFIM=$(date +%H:%M:%S)
        echo -e "$MF \t | $HORAINIC \t | $HORAFIM" >> exper_logs.txt
    fi
  #  sleep 1;
done

IFS=$oldIFS # Restabelece o separador de campo padrão.

