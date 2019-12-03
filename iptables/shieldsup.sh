#!/bin/bash

iptrestore='/sbin/iptables-restore'
ipt='/sbin/iptables'
shieldsupfconf='/PATH/TO/shieldsup.firewall.conf'

case $1 in 

start) 
       echo 'starting firewall - drop everything and log' 
       $iptrestore < $shieldsupfconf
       ;;
stop)  echo 'stopping firewall'
       $ipt -P INPUT ACCEPT
       $ipt -P FORWARD ACCEPT
       $ipt -P OUTPUT ACCEPT
       $ipt -F
       $ipt -X
       $ipt -t nat -F
       $ipt -t nat -X
       $ipt -t mangle -F
       $ipt -t mangle -X
       ;;
*)  echo "$0 start|stop"
    exit 1
    ;;

esac
