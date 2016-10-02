#. ./libfilesys.sh
#. ./../miscs/paths.conf
#. ./libfuncsbase.sh
#. ./../iptrules.sh

# Возвращает название дистрибутива для которого был установлен скрипт
function load4os {
    local distro=$(buildpath "$DISTR" "$SPWD")
    OS=$(head -1 "$distro")
    local list=$(buildpath "$PACKSPATH" "$SPWD")"/$OS.list"
    loadconfs "$list"
}

# Загрузчик модуля обработки правила
function loadhandler {
    local ext="$1"
    [ "$1" ] || ext="bash"
    local module="MODULE_$(echo $ext | sed 's/[[:lower:]]/\u&/g')"
    [ "${!module}" ] && {
        log "${!module}"
        return 0
    }
    local file=$(buildpath "$MODULES" "$SPWD")"/module_$ext.pack"
    loadconfs "$file"
    [ "${!module}" ] && {
        log "${!module}"
        return 0
    }
    log "$loadmoduleerr$1 ($file)"
    return -1
}

# Делает все необходимые действия для установки скрипта
function installscript {
    local distro=$(buildpath "$DISTR" "$SPWD")
    kindofdistr > "$distro"

    createdir "$MAINPATH"
    for lnk in $(echo "$ETCLINKS"); do
        local link="$(buildpath "$lnk" "$SPWD")"
        local goal="$(buildpath "$MAINPATH" "$SPWD")"
        createlink "$link" "$goal"
    done
    rm "$USRLINK" > /dev/null
    log '#!/bin/bash\n' "$USRLINK"
    log 'BACK=$(pwd)' "$USRLINK"
    log "cd $SPWD" "$USRLINK"
    log "$0"' $1 $2 $3 $4' "$USRLINK"
    log 'cd $BACK' "$USRLINK"
    chmod 760 "$USRLINK"
    load4os
    installpackages
    testpack || stopuniversal
    log "installscript"
    return 0
}

# Проверяет, был ли установлен скрипт
function checkinstalled {
    distro=$(buildpath "$DISTR" "$SPWD")
    checkobject "$distro" && return 0
    return -1
}

# Загружает правила
function loadrules {
    local pth=$(buildpath "$RULESBUILDPATH" "$SPWD")
    local data=$(ls "$pth")

    while read NAME; do
        local ext=$(getext "$NAME")
        local proc=$(loadhandler "$ext") || {
            log "$proc"
            continue
        }

        # Модуль загружен. Можно обрабатывать правила
        local result=" - rule loaded."
        log "$proc"
        ${proc}
        #"$proc" "$NAME" || result=" - rule not loaded!"
        #log "$NAME $result"
    done < <(echo "$data")
    testproc "kjdwhsk"
}

# Процедура прописывает признак универсальной OC и завершает скрипт
function stopuniversal() {
        local distro=$(buildpath "$DISTR" "$SPWD")
        rm "$distro"
        log "universalos" "$distro"
        log "$installationerr"
        exit -5
}

