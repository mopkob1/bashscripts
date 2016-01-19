#!/bin/bash

source ./vars
function sync_confs(){
    rsync -avr "$PTH_SRC" "$PTH_TFTP"
}
sync_confs
service tftpd-hpa restart