NETFILTER="/usr/sbin/netfilter-persistent"

# Процедура сохраняет текущее состояние правил
function savestate {
    /usr/sbin/netfilter-persistent save
    RULESSAVEPATH
    MAILPATH

    log "savestate"
}

# Процедура очищает цепочки
function clearrules {
    log "cleanrules"
}

# Процедура фиксирует состояние правил для поднятия после перезагрузки
function commitstate {
    log "commitrulles"
}

# Процедура доустанавливает необходимые пакеты
function installpackages {
    apt-get -y update || return -1
    apt-get -y install iptables-persistent || return -2
    return 0
}

# Процедура проверяет, запускается ли нужный пакет
function testpack(){
    $NETFILTER || return -1
    return 0
}