#!/bin/bash

grep -E -v "(^#|#$|^$)" "./list" |\
    while read ADDR; do
	echo "Sync with $ADDR"
	ping -c 3 "$ADDR" > /dev/null && rsync -avr "$ADDR:/root/.ssh/" "$ADDR"
    done
