#!/bin/bash

SPWD="/opt/bash/bashscripts/manageiptables"
#. "$SPWD/vars"
#. "$SPWD/libs/libfuncsbase.sh"
. ./vars
. ./libs/libfuncsbase.sh
. ./libs/libfuncscommands.sh
. ./libs/libfilesys.sh
. ./libs/libfuncspec.sh
. ./libs/libiptrules.sh
. ./libs/libuniversalos.sh

. ./libs/init.sh

#help "$1"

installscript
exit 0
checkinstalled && load4os || installscript
savestate
clearrules
loadrules
commitstate
rm $(buildpath "$DISTR" "$SPWD")


