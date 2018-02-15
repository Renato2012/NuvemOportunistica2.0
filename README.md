

# Instruções Gerais


#### A descrição completa desse projeto pode ser obtida [aqui](http://www.repositorio.ufc.br/handle/riufc/25186).
#### Para citar este trabalho use essa [publicação](http://sbrc2016.ufba.br/downloads/WCGA/154946_1.pdf).
#### Uma versão anterior desse projeto pode ser encontrada [aqui](https://github.com/Renato2012/NuvemOportunistica).



* Instale as dependencias com o script abaixo.

```
sudo ./dependencias.sh
```

## Passos da Instalação

* Siga os passos a seguir para instalar sua nuvem!

### Passo 1

* Execute o script a seguir \(passando os parametros necessários\) para instalar e configurar o KVM no seu servidor. 

```
./conf_cliente.sh <senha_adm> <senha_one> <nome_maquina> <ip>
```

### Passo 2

* Instale o Gerenciador OpenNebula na máquina a ser o servidor de forma autocontida usando a hierarquia de diretórios: 

*/srv/cloud/one/*

### Passo 3

* Copie as pastas cliente, servidor e dependencias para o diretório home do oneadmin, mude o dono e grupo, use os seguintes comandos:

```
sudo cp -r cliente/ /home/oneadmin/ 
sudo chown -Rf oneadmin.oneadmin /home/oneadmin/cliente/

sudo cp -r servidor/ /home/oneadmin/
sudo chown -Rf oneadmin.oneadmin /home/oneadmin/servidor/

sudo cp -r dependencias/ /home/oneadmin/
sudo chown -Rf oneadmin.oneadmin /home/oneadmin/dependencias/
```

### Passo 4

* Ligue todas as máquinas da rede que deseja que faça parte da nuvem.

* Execute o script para procurar e salvar uma lista com os endereços IPs e outra com os endereços MACs de sua rede.
  
* Será solicitado a interface de rede, digite **br0**. O Script se encontra na pasta */home/oneadmin/cliente/*

```
./procuraMACS.sh
```

* Este script irá gerar os seguintes arquivos de saída: 
listaDeIPs.txt -- contendo os IPs;
listaDeMACs.txt -- contendo os MACs.

### Passo 5

* Execute o script a seguir para instalar o KVM nos clientes e configurá-los.

```
./conexao_oneadmin.sh
```

## Author

* **Renato Araújo**


