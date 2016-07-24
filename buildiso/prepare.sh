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
function copyfiles {
    DST="${WORK}/rootfs"$(echo "${SCRIPTS}" | sed 's/\/$//g')"/"
    cp "./$1" "$DST$1" 
}
function install {
    apt-get -y install "$1"
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
processlist "$SOFT" "install" "BRE" "\t.....OK" "\t.....NOT OK" || exit  #"apt -y install"

log "\nFinding exclude list ..."
[ -e "$EXCLUDE" ] || log "File '$EXCLUDE' - not found!" || exit 
STR=$(log "$WORK" | sed 's/^\///g')"/"
[ "$(grep $STR $EXCLUDE)" ] || log "$STR" "$EXCLUDE"
STR=$(log "$CD" | sed 's/^\///g')"/"
[ "$(grep $STR $EXCLUDE)" ] || log "$STR" "$EXCLUDE"

log "\nBuilding new system ..."
RES=$(rsync -av --one-file-system --exclude-from="$EXCLUDE" ${SOURCE} ${WORK}/rootfs)
log "$RES" "$LOG"

mount  --bind /dev/ ${WORK}/rootfs/dev
mount -t proc proc ${WORK}/rootfs/proc
mount -t sysfs sysfs ${WORK}/rootfs/sys
mount -t devpts devpts ${WORK}/rootfs/dev/pts
log "Go to chroot" "$INDI"

log "Copying scripts to new system ..."
processlist "$COPY" "copyfiles" "BREAK" "\t..... COPIED" "\t..... NOT COPIED!" || exit  #"apt -y install"

message="\n\tType following commands:\n\t\tcd $SCRIPTS\n\t\t./newsystem.sh"
log "$message"



chroot ${WORK}/rootfs /bin/bash

rm "$INDI"
umount ${WORK}/rootfs/dev
umount ${WORK}/rootfs/proc
umount ${WORK}/rootfs/sys

kversion=`cd ${WORK}/rootfs/boot && ls -1 vmlinuz-* | tail -1 | sed 's@vmlinuz-@@'`
cp -vp ${WORK}/rootfs/boot/vmlinuz-${kversion} ${CD}/${FS_DIR}/vmlinuz
cp -vp ${WORK}/rootfs/boot/initrd.img-${kversion} ${CD}/${FS_DIR}/initrd.img
mksquashfs ${WORK}/rootfs ${CD}/${FS_DIR}/filesystem.${FORMAT} -noappend
echo -n $(sudo du -s --block-size=1 ${WORK}/rootfs | tail -1 | awk '{print $1}') | sudo tee ${CD}/${FS_DIR}/filesystem.size
find ${CD} -type f -print0 | xargs -0 md5sum | sed "s@${CD}@.@" | grep -v md5sum.txt | sudo tee -a ${CD}/md5sum.txt
cat "${GRUB}" > ${CD}/boot/grub/grub.cfg
grub-mkrescue -o "$RESULT" "${CD}"