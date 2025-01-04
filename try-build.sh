#!/bin/bash
set -e

if [ -n $1 ]; then
    ECLIPSE_PACKAGE=$1
fi

export ECLIPSE_PACKAGE=${ECLIPSE_PACKAGE:='eclipse-java'}
export ECLIPSE_CONFINED=${ECLIPSE_CONFINED:=false}

. ./set-eclipse-package.sh

CLEAN=${CLEAN:=false}

if $CLEAN; then
    sudo snap remove --purge $ECLIPSE_PACKAGE
    snapcraft clean
fi

# sudo less /var/snap/lxd/common/lxd/logs/lxd.log
snapcraft pack --debug

if $ECLIPSE_CONFINED; then
    sudo snap install ./$(echo $ECLIPSE_PACKAGE)_*_$(dpkg --print-architecture).snap --dangerous
    sudo snap connect $ECLIPSE_PACKAGE:personal-sourcedir
    sudo snap connect $ECLIPSE_PACKAGE:personal-workspace
    sudo snap connect $ECLIPSE_PACKAGE:personal-gitconfig
    sudo snap connect $ECLIPSE_PACKAGE:personal-sshid
    sudo snap connect $ECLIPSE_PACKAGE:personal-maven-cache
else
    sudo snap install ./$(echo $ECLIPSE_PACKAGE)_*_$(dpkg --print-architecture).snap --dangerous --classic
fi

AUTORUN=${AUTORUN:=false}
if $AUTORUN; then
    snap run $ECLIPSE_PACKAGE &
fi
