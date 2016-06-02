#!/bin/bash
FILE="allinall"
grep -E -v "(^#|#$|^$)" "./list" |\
    while read ADDR; do
	cat "./$ADDR/authorized_keys" >> "$FILE.tmp"
    done
cat "$FILE.tmp" | sort | uniq > "$FILE"
rm "$FILE.tmp"