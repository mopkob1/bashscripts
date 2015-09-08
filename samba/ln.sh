#!/bin/bash

. ./conf
. ./msgs
. ./funcs

IP="$1"
init_login "$IP"

SESS="$SESSDIR/$IP"

MAC=$(getpair "$IP" | awk '{print $2}')

CONFSTR=$(grep -v "^#" "$CONF" | grep -v "^$" | grep "$MAC" )
[ "$CONFSTR" ] || error "$MSGACCESSDENIDE $IP - $MAC" "-5" "$LOGFILE"

LOGIN=$(echo "$CONFSTR" | awk '{print $1}')
QUOTE=$(echo "$CONFSTR" | awk '{print $3}')
COMM=$(echo "$CONFSTR" | awk '{print $5}')

DIR="$WORKDIR/$LOGIN"
[ -e "$DIR" ] || LOG=$("$ADDSCRIPT" "$LOGIN")
[ "$LOG" ] && log "$MSGLOGINWARN $DIR" "$LOGFILE"
LOG=$(ln -s "$DIR" "$SESS")

SIZE=$(du -sLBM "$DIR" | awk '{print $1}')
SIZE="${SIZE::${#SIZE}-1}"

[ "$QUOTE" -gt "$SIZE" ] && error "$FULL" "0"
error "$LIM" "0"