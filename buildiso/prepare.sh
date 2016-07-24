#!/bin/bash

LIST="./list"
FROM="../../"
TO="./"

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
help "$1"
. ./vars

log "Making DIR structure ..."
mkdir -p ${CD}/{${FS_DIR},boot/grub} ${WORK}/rootfs || exit

log "Updating package list ..."
#RES=$(apt-get -y update) || exit

log "\nInstalling packages ..."
#Параметры команды конвеера:
#processlist <файл-список> <команда> [BREAK = если прирываемся при ошибке] [вывод при успехе команды] [вывод при не успехе команды] || exit
# без || exit на конце комманды BREAK будет обрвать только конкретный вызов
processlist "$SOFT" "echo" "BRE" "\t.....OK" "\t.....NOT OK" || exit  #"apt -y install"

log "\nFinding exclude list ..."
[ -e "$EXCLUDE" ] || log "File '$EXCLUDE' - not found!" || exit 
STR=$(log "$WORK" | sed 's/^\///g')"/"
[ "$(grep $STR $EXCLUDE)" ] || log "$STR" "$EXCLUDE"
STR=$(log "$CD" | sed 's/^\///g')"/"
[ "$(grep $STR $EXCLUDE)" ] || log "$STR" "$EXCLUDE"

log "\nBuilding new system ..."
RES=$(rsync -av --one-file-system --exclude-from="$EXCLUDE" / ${WORK}/rootfs)
log "$RES" "$LOG"
mount  --bind /dev/ ${WORK}/rootfs/dev
mount -t proc proc ${WORK}/rootfs/proc
mount -t sysfs sysfs ${WORK}/rootfs/sys
log "okk" ${WORK}/rootfs/opt/test
pwd 
cat /opt/test
chroot ${WORK}/rootfs /bin/bash
log "-----------------"
pwd 
cat /opt/test
