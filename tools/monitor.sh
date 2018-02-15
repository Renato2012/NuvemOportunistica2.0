#!/bin/bash
#
# Renato
# 
# Mostra o estado das VMs.
#
while : ; do onehost list; echo -e "\n"; onevm list; sleep 1; done


