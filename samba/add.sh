#!/bin/bash

function error {
    echo -e "$1"
    [ "$2" ] || exit -3
    exit "$2"
}
function help {
    MSG="Usage:\n\n\t$1 username\n\n\t when you put config in $2"
    MSG=$MSG"\n\n\n\t$1 username IPadress quote\n\n\tin command-line mode"
    error "$MSG" "0"
}
function writeperm {
# Записывает пользователя в конфиг системы
    CF="$1";L="$2"; I="$3"; Q="$4"; M="$5"; C="$6";
    mv "$CF" "$CF.tmp"
    grep -v "$I" "$CF.tmp" > "$CF"
    echo -e "$L\t$I\t$Q\t$M\t#$C" >> "$CF"
    rm "$CF.tmp"
}
function showuser {
# Выводит параметры пользователя на экран
    echo -e "User:\t\t$1"
    echo -e "IP:\t\t$2"
    echo -e "MAC:\t\t$4"
    echo -e "Quote:\t\t$3 Mb"
    echo -e "Comments:\t$5"
    echo -e "Work dir:\t$6"
}
function createworkdir {
# Создает директорию и ограничивает запись в нее 
    DIR="$1"
    mkdir -p "$DIR" || error "$2$DIR" "-2"
}
CONF="./smbusers"
ARP="/usr/bin/arp-scan"
WORKDIR="/srv/net/smb/users/"

MSGBADIP="IP not found! Turn on the workstation or put intently IP adress."
MSGBADDIR="Can't create dir: "
LOGIN=$1
[ "$LOGIN" ] || help "$0" "$CONF"
CONFSTR=$(grep "$LOGIN" "$CONF")
[ "$CONFSTR" ] || CONFSTR="$1 $2 $3"
IP=$(echo "$CONFSTR" | awk '{print $2}')
QUOTE=$(echo "$CONFSTR" | awk '{print $3}')

PAIR=$("$ARP" "$IP" | sed -n '3p')
PAIR="192.168.222.35 f0:4d:a2:4d:64:13"
[ "$PAIR" ] || error "$MSGBADIP"
[ "$QUOTE" ] || QUOTE="0"

MAC=$(echo "$PAIR" | awk '{print $2}')
COMM=$(echo "$CONFSTR" | awk -F'#' '{print $2}')

createworkdir "$WORKDIR$LOGIN"
writeperm "$CONF" "$LOGIN" "$IP" "$QUOTE" "$MAC" "$COMM"
showuser "$LOGIN" "$IP" "$QUOTE" "$MAC" "$COMM" "$WORKDIR$LOGIN"