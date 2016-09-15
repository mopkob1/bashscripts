#!/usr/bin/env bash


# Инициализация настроек скелета

. ./vars
. ./libs/libfuncsbase.sh
. ./libs/libfuncscommands.sh


FILE_UID=$(date "+%d_%m_%y_%H%M")

loadconfs "$(buildpath $CONFPATH $SPWD)"
                                                 #---------------------------------------------

