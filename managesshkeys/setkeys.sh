#!/bin/bash
#Тест
grep -E -v "(^#|#$|^$)" "./list" |\
    while read ADDR; do
	echo "Sync with $ADDR"
	rsync -avr --exclude="*.bak" "./$ADDR/" "$ADDR:/root/.ssh/" 
    done
