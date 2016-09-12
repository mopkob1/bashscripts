# Процедура сохраняет текущее состояние правил
function savestate {
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
    log "installpackages"
}