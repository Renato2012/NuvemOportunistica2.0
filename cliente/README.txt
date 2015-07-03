Autor: Renato Cavalcante
data: 15/11/2014

#=======================================================================#
# No Cliente
#=======================================================================#


Instruções do módulo cliente.


enviar_cliente
	Esta pasta contem os arquivos a serem enviados aos clientes remotos da nuvem privada.

liga-desliga.sh
	Script de administração da nuvem, ao executá-lo, se pode desligar, ligar e reiniciar de forma automática todas as máquinas clientes da nuvem.

procuraMACs.sh
	Será chamado pelo script dependencias.sh.
	Durante a execução do script procuraMACs.sh será gerados os arquivos:

I) listaDeIPs.txt
	Contém os endereços IPs de todas as máquinas que estejam ligadas e conectadas na rede do servidor.

II) listaDeMACs.txt
	Contém os endereços MACs de todas as máquinas que estejam ligadas e conectadas na rede do servidor.

III) ListaIPsEnviados.txt
	Contém os IPs de das máquinas que já foram configuradas como cliente da nuvem privada oportunística.

IV) variaveis
	Contém as seguintes informações: IP do servidor; IP da subrede e mascara da subrede.

Após executar o script procuraMACs.sh, se pode executar o script conexao_oneadmin.sh para instalar e configurar os hosts remotos na sua nuvem privada.

one.sh
	Este script é chamado pelo servidorThread.py mais especificamente pelo módulo tomadecisoes.py, para iniciar o OpenNebula e monitorar os recursos da nuvem, em caso de detecção de falta de recursos, one.sh irá ligar máquinas clientes da nuvem que estejam desligadas para prover infraestrutura suficiente à nuvem.


