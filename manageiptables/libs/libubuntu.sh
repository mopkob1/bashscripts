#. ./../miscs/paths.conf
NETFILTER="/usr/sbin/netfilter-persistent"
IPT="/sbin/iptables"

# Процедура сохраняет текущее состояние правил
function savestate {
    commitstate
    local file=$(buildpath "$RULESSAVEPATH" "$SPWD")"/$FILE_UID.state"

    cat "$(buildpath "$MAINPATH" "$SPWD")/rules.v4" > "$file" || return -2
    return 0
}

# Процедура очищает цепочки
function clearrules {
    $NETFILTER flush > /dev/null
}

# Процедура фиксирует состояние правил для поднятия после перезагрузки
function commitstate {
    $NETFILTER save 2>&1> /dev/null || return -1
}

# Процедура доустанавливает необходимые пакеты
function installpackages {
    apt-get -y update > /dev/null || return -1
    apt-get -y install iptables-persistent > /dev/null || return -2
    return 0
}

# Процедура проверяет, запускается ли нужный пакет
function testpack(){
    $NETFILTER 2>&1> /dev/null || return -1
    return 0
}