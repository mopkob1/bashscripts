#!/usr/bin/env bash


# Инициализация настроек скелета

. ./vars
. ./libs/libfuncsbase.sh
. ./libs/libfuncscommands.sh

CONFPATH=$(pwd)"/"$(choppath "$CONFPATH")
FILE_UID=$(date "+%d_%m_%y_%H%M")

loadconfs "$CONFPATH"
                                                 #---------------------------------------------

