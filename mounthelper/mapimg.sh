#!/bin/bash
FILE="$1"
echo "Map img-file to loop devs."
[ "$1" ] || echo -e "\t $0 <file.img>"
[ "$1" ] && {
    kpartx -av `losetup -sf "$FILE"` && ls /dev/mapper
}