#!/bin/bash
#
### BEGIN INIT INFO
# Provides:             daemon-cliente
# Required-Start:       $network
# Required-Stop:        $network
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Start daemon-cliente daemon
# Description:          Daemon controla o script clienteThread.py que monitora o# 			computador e envia as estatisticas ao servidor.
### END INIT INFO
# Modelo em: /etc/init.d/skeleton
# Autor: Renato
# 20/10/2014

PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="daemon cliente (clienteThread.py) no diretório /usr/sbin/"
NAME=clienteThread.py
DAEMON=/usr/sbin/cliente_python/$NAME
DAEMON_ARGS="--options args"
PIDFILE=/var/run/$NAME.pid
 
start(){
    echo "start executado em: $(date)" > /var/log/daemon-cliente.log  
    start-stop-daemon --start --background --pidfile $PIDFILE --make-pidfile --startas $DAEMON
}
  
stop(){
    echo "stop executado em: $(date)" > /var/log/daemon-cliente.log
    start-stop-daemon --stop --retry=TERM/30/KILL/15 --pidfile $PIDFILE --name $NAME
    # escreve no arquivo. cliente python ler o /var/log/daemon-cliente.log.
}
  
restart(){
    stop
    start
}                                                                               

case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    restart
    ;;
*)
    echo $"Usage: /etc/init.d/$0 {start|stop|restart}"
    exit 1
    ;;
esac
  
exit 0
