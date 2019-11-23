#!/bin/bash

export HOST='somehost.someplace.com'
export USER='someuser'
export PORT='666'
SSH='/usr/bin/ssh'

case $1 in 

start) 
       echo 'starting SOCKS proxy on port' $PORT 'through' $HOST
       `$SSH -D $PORT -f -C -q -N $USER@$HOST`
       ;;
stop)  echo 'stopping tunnel'
       `kill -TERM $(ps waux |grep ssh|grep $PORT|awk '{print $2}')`
       ;;
*)  echo "$0 start|stop"
    exit 1
    ;;

esac
