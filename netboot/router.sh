#!/bin/bash

source ./vars
echo "1" > "/proc/sys/net/ipv4/ip_forward"
ifconfig "$INT_IFACE" "$ROUTER"
iptables -t nat -A POSTROUTING -s "$INT_NET" -o "$EXT_IFACE" -j MASQUERADE
route add -net "$INT_NET" gw "$ROUTER"
#iptables -A FORWARD -i "$EXT_IFACE" -o "$EXT_IFACE" -j REJECT
#iptables -I FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
