
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
    return 0
}

# Процедура проверяет, запускается ли нужный пакет
function testpack(){
    return 0
}