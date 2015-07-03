#!/bin/bash
# Renato
# 14/10/2014

# Script instala e configura o kvm, cria usuário e grupo oneadmin e configura a interface bridge.

# Recebe remotamente a senha adm, o nome da máquina cliente, e o IP da máquina cliente como parametro.
#=== Os 3 primeiros parametros são passados para instalar no servidor. ===#
senha=$1
nome_maquina=$2
ip=$3
#=== Os 3 parametros anteriores mais os 2 abaixo, são passados para execução remota ===#
ip_servidor=$4
maquina_servidor=$5

# Verificar se foi passado 3 parametros necessários para execução no servidor.
if [ $# -lt 3 ]; then
    echo "Passe quatro parametros.
          Uso: $0 adm_senha nome_maquina ip"
    exit 0
fi

# Instalar kvm.
echo $senha | sudo -S apt-get -y install ubuntu-virt-server kvm-ipxe bridge-utils ubuntu-vm-builder ruby nfs-common

# Modo gráfico kvm. 
echo $senha | sudo -S apt-get -y install virt-manager

# Configurar arquivo do kvm.
echo $senha | sudo -S sed -i 's/#user = "root"/user = "root"/' /etc/libvirt/qemu.conf
echo $senha | sudo -S sed -i 's/#group = "root"/group = "root"/' /etc/libvirt/qemu.conf
echo $senha | sudo -S sed -i 's/#dynamic_ownership = 1/dynamic_ownership = 0/' /etc/libvirt/qemu.conf

# Criar usuário e grupo oneadmin.
echo $senha | sudo -S groupadd --gid 999 oneadmin
echo $senha | sudo -S useradd -u 999 -g oneadmin -s /bin/bash -d /home/oneadmin oneadmin
echo $senha | sudo -S mkdir -p /home/oneadmin/
echo $senha | sudo -S chown -Rf oneadmin.oneadmin /home/oneadmin/
echo $senha | sudo -S chmod 700 /home/oneadmin/

# Adicionar usuário oneadmin ao grupo libvirtd e kvm
echo $senha | sudo -S usermod -a -G libvirtd oneadmin
echo $senha | sudo -S usermod -a -G kvm oneadmin

# Copiar diretório .ssh do servidor para o usuário oneadmin.
echo $senha | sudo -S cp -R .ssh /home/oneadmin/
echo $senha | sudo -S chown -Rf oneadmin.oneadmin /home/oneadmin/.ssh

# Configurar bridge com dhcp. Inserir texto na linha após(parametro a) loopback. Com quebra de linha (\n) e tabulação (\t) no arquivo /etc/network/interfaces. 
echo $senha | sudo -S sed -i -e '/loopback/a \\nallow-hotplug br0 \niface br0 inet dhcp \n\tbridge_ports eth0 \n\tbridge_maxwait 0' /etc/network/interfaces

# Subir a bridge criada.
echo $senha | sudo -S ifup br0

# Subir a bridge sempre que o sistema iniciar.
echo $senha | sudo -S sed -i -e '$a\' -e 'ifup br0' /etc/init.d/rc.local 

# Reiniciar a interface de rede.
echo $senha | sudo -S /etc/init.d/networking restart

# Configurar arquivo /etc/sudoers. Para o usuário oneadmin executar comandos como sudo sem solicitar senha de administrador.
if [ ! -e /etc/sudoers.backup ]; then	# Se arquivo não existir entra no bloco.
    echo $senha | sudo -S cp /etc/sudoers /etc/sudoers.backup
    # $a\ após tudo, no fim.
    echo $senha | sudo -S sed -i -e '$a\' -e 'oneadmin ALL=NOPASSWD:ALL' /etc/sudoers
fi

## Configurar o arquivo /etc/hosts da máquina remota.
echo $senha | sudo -S hostname "$nome_maquina"
echo $senha | sudo -S sed -i 's/.*/'"$nome_maquina"'/' /etc/hostname
echo $senha | sudo -S sed -i '2s/.*/'"$ip"'\t'"$nome_maquina"'/' /etc/hosts

# Condição para executar o bloco abaixo apenas quando for chamado remoto, e não executar no servidor que é passado apenas 3 parametros. 
if [ $# == 5 ]; then
    echo $senha | sudo -S sed -i '/^$/i\'"$ip_servidor"'\t'"$maquina_servidor"'' /etc/hosts

# Criar diretório para a montagem do NFS.
    echo $senha | sudo -S mkdir -p /srv/cloud/one/var/datastores
    echo $senha | sudo -S chown -R oneadmin.oneadmin /srv/

# Renomeia o arquivo /sbin/shutdown para /sbin/shutdown_main, após renomear copia o shutdown implementado para o diretório /sbin do antigo shutdown (shutdown_main).
# Ao tentar desligar a maquina física o shutdown(implementado) será chamado, que verifica se tem VMs em execução, e avisa ao servidor nuvem, para migrá-las,
# só após a migração é que o desligamento acontece. 
    echo $senha | sudo -S mv /sbin/shutdown /sbin/shutdown_main
    echo $senha | sudo -S cp shutdown /sbin/
    echo $senha | sudo -S chmod 755 /sbin/shutdown
fi
