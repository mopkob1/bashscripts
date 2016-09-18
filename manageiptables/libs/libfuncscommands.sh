#!/usr/bin/env bash

# Библиотека функций-комманд для функции processlist


# Команда для установки пакетов для Debian
# Пример использования:
#                       processlist "$ISOSOFT" "install" "BRE" "\t.....OK" "\t.....NOT OK" || exit  #"apt -y install"
function install {
    apt-get -y install "$1"
}

#
function echoline(){
    A=3
    return 0
    #log "$1|$2|$3|$4"
}