#!/usr/bin/env bash

# Библиотека базовых функций для bash-скриптов

function help {

    [ "$SPWD" ] && SPWD=$(pwd)
    local pth=$(buildpath `dirname "$HELPMSG"` "$SPWD")
    local file=$(basename "$HELPMSG")
    loadconfs "$pth" "$file"

    local message="$welcome"
    [ "$1" ] || message="$message$adds"
    [ "$1" = "--help" ] && message="$welcome$help"
    log "$message"
    [ "$1" = "--help" ] && exit 0
}

# Процедура вывода на экаран лдибо в log-файл
function log {
    [ "$2" ] || echo -e "$1" 			#выдать на на экран
    [ "$2" ] && echo -e "$1" >> "$2" 		#записать в log-file
}

#Процедура-конвеер. Вызывает команду (второй параметр) для каждой записи из файла (первый параметр
#Параметры команды конвеера:
#processlist <файл-список> <команда> [BREAK = если прирываемся при ошибке] [вывод при успехе команды] [вывод при не успехе команды] || exit
# без || exit на конце комманды BREAK будет обрвать только конкретный вызов

# Пример использования:
#                       processlist "$ISOSOFT" "install" "BRE" "\t.....OK" "\t.....NOT OK" #"apt -y install"
# Процедура годится только для выполнения команд, которые не возвращают данных в скрипт

function processlist {
    local PEXIT=""
    local data=$(awk -F'#' '{print $1}' "$1" | grep -E -v "(^#|#$|^$)" | sed 's/  / /g' | sed 's/^ //g')
    while read LINE; do
        local R=$("$2" "$LINE") || PEXIT="26"
        [ "$4" ] && ([ "$PEXIT" ] || log "\t$LINE $4")
        [ "$5" ] && ([ "$PEXIT" ] && log "\t$LINE $5")
        [ "$4" ] || ([ "$R" ] && log "$R")
        [ "$3" = "BREAK" ] && {
            [ "$PEXIT" ] &&  exit "$PEXIT"
        }
    done < <(echo $data)
    return 0;
}

###
# loadconfs - Процедура загрузки дополнительных конфигурационных файлов
# $1 - Либо имя файла со списком загружаемых файлов (один параметр)
#       либо путь к загружаемым файлам
# $2 - Имя файла либо выражение REGEXP для загружаемых файлов
###
function loadconfs {
    local list=""
    local pth=""

    [ "$2" ] || {
        list=$(cat "$1") || return -1
    }
    [ "$2" ] && {
        pth=$(echo "$1" | sed 's/\/$//g')"/"
        [ -d "$pth" ] || log "No load path found: $pth" \
                      && list=$(ls "$pth" | grep -E "$2")
    }
    for FILE in $(echo "$list")
    do
        [ -e "$pth$FILE" ] && . "$pth$FILE" || log "Can't load $pth$FILE"
    done
}

#
function loadlibs(){
    [ -d "$2" ] && pth=$(echo "$2" | sed 's/\/$//g')"/"
    while read FILE; do
        log "$pth$FILE"
    done < $(cat "$1")
}

