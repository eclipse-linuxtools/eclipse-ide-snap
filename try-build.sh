#!/bin/bash
set -e

if [ -n $1 ]; then
    ECLIPSE_PACKAGE=$1
fi

export ECLIPSE_PACKAGE=${ECLIPSE_PACKAGE:='eclipse-java'}
export ECLIPSE_ARCH=${ECLIPSE_ARCH:=`dpkg --print-architecture`}

. ./set-eclipse-package.sh

CLEAN=${CLEAN:=false}

if $CLEAN; then
    sudo snap remove --purge $ECLIPSE_PACKAGE
    snapcraft clean
fi

# sudo less /var/snap/lxd/common/lxd/logs/lxd.log
snapcraft pack --debug

AUTORUN=${AUTORUN:=false}
if $AUTORUN; then
    snap run $ECLIPSE_PACKAGE &
fi
