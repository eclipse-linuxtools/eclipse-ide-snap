#!/bin/bash
SOURCE=$(dirname -- ${BASH_SOURCE[0]})
echo source-root: $SOURCE

export ECLIPSE_PACKAGE=${ECLIPSE_PACKAGE:='eclipse-java'}
echo setting up for $ECLIPSE_PACKAGE
export ECLIPSE_ARCH=${ECLIPSE_ARCH:=`dpkg --print-architecture`}
echo target arch is $ECLIPSE_ARCH

SNAPCRAFT_YAML=$SOURCE/snap/snapcraft.yaml

YGLU_ENABLE_ENV=true pipx run --pip-args "-r requirements.txt" yglu snapcraft.yaml.template | tee $SNAPCRAFT_YAML

if [ $? -eq 0 ]; then
    echo written $SNAPCRAFT_YAML for $ECLIPSE_PACKAGE.
else
    echo ERROR see above.
    return 1
fi
