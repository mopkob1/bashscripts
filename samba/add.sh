#!/bin/bash
. ./conf		#Конфигурация
. ./msgs		#Сообщения
. ./funcs		#Функции

init_add

LOGIN=$1
[ "$LOGIN" ] || error "$MSGHELPADD" "0"
CONFSTR=$(grep "$LOGIN" "$CONF")
[ "$CONFSTR" ] || CONFSTR="$1 $2 $3"
IP=$(echo "$CONFSTR" | awk '{print $2}')
QUOTE=$(echo "$CONFSTR" | awk '{print $3}')

PAIR=$(getpair "$IP")
PAIR="192.168.222.35 f0:4d:a2:4d:64:13" #Только для теста. Убрать
[ "$PAIR" ] || error "$MSGBADIP"
[ "$QUOTE" ] || QUOTE="0"


MAC=$(echo "$PAIR" | awk '{print $2}')
COMM=$(echo "$CONFSTR" | awk -F'#' '{print $2}')

createworkdir "$WORKDIR/$LOGIN"
writeperm "$CONF" "$LOGIN" "$IP" "$QUOTE" "$MAC" "$COMM"
showuser "$LOGIN" "$IP" "$QUOTE" "$MAC" "$COMM" "$WORKDIR/$LOGIN"