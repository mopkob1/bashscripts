#!/usr/bin/env bash

# Библиотека базовых функций для bash-скриптов

function help {
    . "$HELPMSG"

    message="$welcome"
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
#                       processlist "$ISOSOFT" "install" "BRE" "\t.....OK" "\t.....NOT OK" || exit  #"apt -y install"
# Процедура годится только для выполнения команд, которые не возвращают данных в скрипт

function processlist {

awk -F'#' '{print $1}' "$1" | grep -E -v "(^#|#$|^$)" | sed 's/  / /g' | sed 's/^ //g' | \
    while read LINE; do
	R=$("$2" "$LINE") || EXIT="26"

	[ "$4" ] && [ "$EXIT" ] || log "\t$LINE $4"
	[ "$5" ] && [ "$EXIT" ] && log "\t$LINE $5"
	[ "$4" ] || log "$R"
	[ "$3" = "BREAK" ] && [ "$EXIT" ] &&  exit "$EXIT"
    done
    return 0;
}

# Процедура обрезает первый и последний '/' в пути и признак относительного пути './'
function choppath {
    echo "$1" | sed 's/\/$//g' | sed 's/^.//g' | sed 's/^\///g'
}

# Процедура загрузки дополнительных конфигурационных файлов
function loadconfs {
    pth=$1
    for FILE in $(ls "$pth" | grep -E ".conf$" )
    do
        . "$pth/$FILE"
    done
}
