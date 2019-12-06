#!/bin/bash

iptrestore='/sbin/iptables-restore'
ipt='/sbin/iptables'

case $1 in 

start) 
       echo 'starting redsocks rules' 
       $ipt -t nat -N REDSOCKS
       # Exclude local and reserved addresses
       $ipt -t nat -A REDSOCKS -d 0.0.0.0/8 -j RETURN
       $ipt -t nat -A REDSOCKS -d 10.0.0.0/8 -j RETURN
       $ipt -t nat -A REDSOCKS -d 127.0.0.0/8 -j RETURN
       $ipt -t nat -A REDSOCKS -d 169.254.0.0/16 -j RETURN
       $ipt -t nat -A REDSOCKS -d 172.16.0.0/12 -j RETURN
       $ipt -t nat -A REDSOCKS -d 192.168.0.0/16 -j RETURN
       $ipt -t nat -A REDSOCKS -d 224.0.0.0/4 -j RETURN
       $ipt -t nat -A REDSOCKS -d 240.0.0.0/4 -j RETURN
       $ipt -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 12345
       # Redirect all HTTP and HTTPS outgoing packets through Redsocks
       $ipt -t nat -A OUTPUT -p tcp --dport 443 -j REDSOCKS
       $ipt -t nat -A OUTPUT -p tcp --dport 80 -j REDSOCKS
       $ipt -t nat -A PREROUTING -p tcp --dport 443 -j REDSOCKS
       $ipt -t nat -A PREROUTING -p tcp --dport 80 -j REDSOCKS
       # push through my local socks SSH -D tunnel
       #$ipt -t nat -A PREROUTING -p tcp --dport YOUREXTERNALSOCKSPORT -j REDSOCKS
       ;;
stop)  echo 'stopping redsocks'
       $ipt -t nat -F
       $ipt -t nat -X
       $ipt -t nat -L -v -n
       ;;
*)  echo "$0 start|stop"
    exit 1
    ;;

esac
