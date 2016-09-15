#!/usr/bin/env bash


# Инициализация настроек скелета



FILE_UID=$(date "+%d_%m_%y_%H%M")

loadconfs "$(buildpath $CONFPATH $SPWD)" ".conf$"
                                                 #---------------------------------------------

