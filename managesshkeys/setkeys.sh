#!/bin/bash
#Тест
grep -E -v "(^#|#$|^$)" "./list" |\
    while read ADDR; do
	echo "Sync with $ADDR"
	ping -c 2 "$ADDR" > /dev/null && rsync -avr --exclude="*.bak" "./$ADDR/" "$ADDR:/root/.ssh/" 
    done
