#!/bin/bash

grep -E -v "(^#|#$|^$)" "./list" |\
    while read ADDR; do
	echo "Sync with $ADDR"
	rsync -avr "$ADDR:/root/.ssh/" "$ADDR"
    done
