# Процедура обрезает первый и последний '/' в пути и признак относительного пути './'
function choppath {
    echo "$1" | sed 's/\/$//g' | sed 's/^\.//g' | sed 's/^\///g'
}

###
# buildpath - Превращает относительный путь в абсолютный
# $1 - Относительный путь. Обязательный параметр.
# $2 - То, до чего должен быть достроин путь (pwd - по умолчанию). НЕОбязательный параметр.
###
function buildpath(){

    [ "$1" ] || {
        pwd
        return -1
    }
    [ "$(log $1 | grep -E '^/')" ] && {
        log "$1"
        return -2
    }

    [ "$2" ] && pth="/"$(choppath "$2") || pth=$(pwd)
    log "$pth/"$(choppath "$1")
    return 0
}

# Проверяет наличие объекта на диске (файл, ссылка, директория)
function checkobject(){
    [ -e "$1" ] || return -1
    return 0
}

# Проверяет существование директории
function checkdir(){
    [ -d "$1" ] || return -1
    return 0
}

# Создает директорию
function createdir(){
    checkdir "$1" && return 0
    mkdir -p "$1" || return -1
    return 0
}

# Проверяет, есть ли символическая ссылка
function checklink(){
    [ -L "$1" ] || return -1
    return 0
}

###
# createlink - # Создает ссылку на объект
# $1 - Объект
# $2 - Путь создания (абсолютный. В противном случае будет дополнен до pwd)
# $3 - Имя, если отличается от исходного (необязательно)
function createlink(){
    checkobject "$1" || return -1
    checkdir "$(buildpath $2)" || return -2
    ln -s "$1" "$(buildpath $2)/$3" 2> /dev/null && return 0
    return -3
}
# Возвращает экстеншен из имени файла
function getext(){
    basename "$1" | awk -F'.' '{print $2}'
}