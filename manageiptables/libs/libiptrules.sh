#. ./libfilesys.sh
#. ./../miscs/paths.conf
#. ./../iptrules.sh

# Возвращает название дистрибутива для которого был установлен скрипт
function load4os {
    log "load4os"
}

# Делает все необходимые действия для установки скрипта
function installscript {
    distro=$(buildpath "$DISTR" "$SPWD")
    kindofdistr > "$distro"

    createdir "$MAINPATH"
    for lnk in $(echo "$ETCLINKS"); do
        link="$(buildpath "$lnk" "$SPWD")"
        goal="$(buildpath "$MAINPATH" "$SPWD")"
        createlink "$link" "$goal"
    done
    exit 0
    rm "$USRLINK" > /dev/null
    log '#!/bin/bash\n' "$USRLINK"
    log 'BACK=$(pwd)' "$USRLINK"
    log "cd $SPWD" "$USRLINK"
    log "$0"' $1 $2 $3 $4' "$USRLINK"
    log 'cd $BACK' "$USRLINK"
    chmod 760 "$USRLINK"
    rm $distro
    load4os
    installpackages || {
        log "universalos" "$distro"
        log "$installationerr"
        exit -5
    }
    return 0
}

# Проверяет, был ли установлен скрипт
function checkinstalled {
    distro=$(buildpath "$DISTR" "$SPWD")
    checkobject "$distro" && return 0
    return 1
}

# Загружает правила
function loadrules {
    log "loadrules"
}
