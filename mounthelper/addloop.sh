#!/bin/bash

echo "Add more than 8 loop-devs to the system."
echo -e "\t$0 [START] [FINISH]"

FINISH="$2"
START="$1"

[ "$1" ] || START="8"
[ "$2" ] || FINISH="63"
for i in "{$START..$FINISH}"; do if [ -e /dev/loop$i ]; then continue; fi; mknod /dev/loop$i b 7 $i; chown --reference=/dev/loop0 /dev/loop$i; chmod --reference=/dev/loop0 /dev/loop$i; done
