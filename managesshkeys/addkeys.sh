#!/bin/bash
FILE="allinall"
DATE=$(date "+%d_%m_%y_%H_%M")
grep -E -v "(^#|#$|^$)" "./list" |\
    while read ADDR; do
	OWN=$(cat "./$ADDR/id_rsa.pub" || echo "ERROR")
	grep -E -v "(^#|#$|^$)" "$FILE" >> "./$ADDR/$FILE.tmp" 
	cat "./$ADDR/authorized_keys" > "./$ADDR/$DATE.bak"
	cat "./$ADDR/authorized_keys" >> "./$ADDR/$FILE.tmp" 
	cat "./$ADDR/$FILE.tmp" | sort | uniq | grep -v "$OWN" > "./$ADDR/authorized_keys"
	rm "./$ADDR/$FILE.tmp" 
    done

