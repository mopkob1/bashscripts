# Прооцедура определяет дистрибутив на котором работает скрипт

function kindofdistr {
    [ "$(cat /etc/*release | grep -i ubuntu | grep -v -i "like")" ] && log "ubuntu"
    [ "$(cat /etc/*release | grep -i centos | grep -v -i "like")" ] && log "centos"
    [ "$(cat /etc/*release | grep -i debian | grep -v -i "like")" ] && log "debian"
    [ "$(cat /etc/*release | grep -v -i "like" | grep -E -i '(centos|debian|ubuntu)')" ] || log "universalos"
}