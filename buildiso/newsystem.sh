#!/bin/bash

function help {
    welcome="\nBuild bootable ISO-image from existing linux-system. 2016 (c) ituse.ru \n"
    adds="\t Help:\n\t\t $0 --help\n\n"
    help="\tUsage:\n\t\tto Backup:\t $0\n\t\tto Recovery:\t $0 <any string>\n"

    message="$welcome"
    [ "$1" ] || message="$message$adds"
    [ "$1" = "--help" ] && message="$welcome$help"
    log "$message"
    [ "$1" = "--help" ] && exit 0
}

function log {
    [ "$2" ] || echo -e "$1" 			#выдать на на экран
    [ "$2" ] && echo -e "$1" >> "$2" 		#записать в log-file
}
function processlist {
#Процедура-конвеер. Вызывает команду (второй параметр) для каждой записи из файла (первый параметр
#Параметры команды конвеера:
#processlist <файл-список> <команда> [BREAK = если прирываемся при ошибке] [вывод при успехе команды] [вывод при не успехе команды] || exit
# без || exit на конце комманды BREAK будет обрвать только конкретный вызов

awk -F'#' '{print $1}' "$1" | grep -E -v "(^#|#$|^$)" | sed 's/  / /g' | sed 's/^ //g' | \
    while read LINE; do
	R=$("$2" "$LINE") || EXIT="26"

	[ "$4" ] && [ "$EXIT" ] || log "\t$LINE $4"
	[ "$5" ] && [ "$EXIT" ] && log "\t$LINE $5"
	[ "$4" ] || log "$R" 
	[ "$3" = "BREAK" ] && [ "$EXIT" ] &&  exit "$EXIT"
    done
    return 0
}
function install {
    apt-get -y install "$1"
}
function remove {
    DST=$(echo "${SCRIPTS}" | sed 's/\/$//g')"/"
    rm "$DST$1" 

}

help "$1"
. ./vars

[ -e "$INDI" ] || log "File '$INDI' - not found! Possible you are not in chroot ..." || exit 

log "Making DNS ..."
[ -e "$RMLIST" ] || log "File '$RMLIST' - not found!" || exit 

mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts

export HOME=/root
export LC_ALL=C

processlist "$RMLIST" "rm" "br" "\t .... REMOVED." "\t .... NOT REMOVED!"
log "nameserver 8.8.8.8" "/etc/resolv.conf"
log "Making swap ..."
dd if=/dev/zero of=/swapfile bs=2M count=1024
mkswap /swapfile

log "Updating package list ..."
RES=$(apt-get -y update) || exit
log "\nInstalling packages ..."


processlist "$ISOSOFT" "install" "BRE" "\t.....OK" "\t.....NOT OK" || exit  #"apt -y install"

dbus-uuidgen > /var/lib/dbus/machine-id


log "Preparing new system ..."
depmod -a $(uname -r)
update-initramfs -u -k $(uname -r)

log "Cleaning new system ..."
processlist "$RMLIST" "rm" "br" "\t .... REMOVED." "\t .... NOT REMOVED!"
processlist "$COPY" "remove" "br" "\t .... REMOVED." "\t .... NOT REMOVED!"
rm /var/lib/dbus/machine-id 
rm -rf /tmp/*
RES=$(apt-get -y clean)
find /var/log -regex '.*?[0-9].*?' -exec rm -v {} \;

find /var/log -type f | while read file
do
    cat /dev/null | tee $file
done
log "Type exit to finish chroot..."
umount /proc /sys /dev/pts