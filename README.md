Autor: Renato Cavalcante  
data: 13/10/2014

####=========================================
# Instruções Gerais

Instale as dependencias com o script abaixo.  
sudo ./dependencias.sh

Siga os passos a seguir para instalar sua nuvem!
### Passo 1:
Execute o script a seguir para instalar e configurar o KVM no seu servidor.  
./conf_cliente.sh <\senha_adm> <\senha_one> <\nome_maquina> <\ip>

### Passo 2:
Instale o Gerenciador OpenNebula na máquina a ser o servidor de forma autocontida usando a hierarquia de diretórios:  
/srv/cloud/one/

### Passo 3:
Copie as pastas cliente, servidor e dependencias para o diretório home do oneadmin, mude o dono e grupo, use os seguintes comandos:  
sudo cp -r cliente/ /home/oneadmin/  
sudo chown -Rf oneadmin.oneadmin /home/oneadmin/cliente/

sudo cp -r servidor/ /home/oneadmin/  
sudo chown -Rf oneadmin.oneadmin /home/oneadmin/servidor/

sudo cp -r dependencias/ /home/oneadmin/  
sudo chown -Rf oneadmin.oneadmin /home/oneadmin/dependencias/

### Passo 4:
Ligue todas as máquinas da rede que deseja que faça parte da nuvem.   

Execute o script para procurar e salvar uma lista com os endereços IPs, e outra com os Endereços MACs de sua rede.
  
Irá solicitar a interface de rede, digite br0. O Script se encontra dentro da pasta /home/oneadmin/cliente    
./procuraMACS.sh

Este script irá gerar os arquivos listaDeIPs.txt, listaDeMACs.txt contendo os IPs e MACs, respectivamente.  

### Passo 5:
Execute o script a seguir para instalar o kvm nos clientes e configura-los.  
./conexao_oneadmin.sh



