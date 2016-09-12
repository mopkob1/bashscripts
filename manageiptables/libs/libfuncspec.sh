# Прооцедура определяет дистрибутив на котором работает скрипт

function kindofdistr {
    [ "$(cat /etc/*release | grep -i ubuntu)" ] && log "ubuntu"
    [ "$(cat /etc/*release | grep -i centos)" ] && log "centos"
    [ "$(cat /etc/*release | grep -i debian)" ] && log "debian"
}