#!/bin/bash

LIST="./list"
FROM="../../"
TO="./"

function sync {
    log "$4\n"
    rsync -avr "--files-from=$1" "$2" "$3"
}

function help {
    welcome="\nSimple sync config. 2016 (c) me-so.ru \n"
    adds="\t Help:\n\t\t $0 --help\n\n"
    help="\tUsage:\n\t\tto Backup:\t $0\n\t\tto Recovery:\t $0 <any string>\n\n"

    message="$welcome"
    [ "$1" ] || message="$message$adds"
    [ "$1" = "--help" ] && message="$welcome$help"
    log "$message"
    [ "$1" = "--help" ] && exit 0
}

function log {
    [ "$2" ] || echo -e "$1"
    [ "$2" ] && echo -e "$1" >> "$2"
}

help "$1"
[ "$1" ] || sync "$LIST" "$FROM" "$TO" "Backup process ..."
[ "$1" ] && sync "$LIST" "$TO" "$FROM" "Recovery process ..."