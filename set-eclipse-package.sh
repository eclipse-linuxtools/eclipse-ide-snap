#!/bin/bash
SOURCE=$(dirname -- ${BASH_SOURCE[0]})
echo source-root: $SOURCE

export ECLIPSE_PACKAGE=${ECLIPSE_PACKAGE:='eclipse-java'}
echo setting up for $ECLIPSE_PACKAGE
export ECLIPSE_CONFINED=${ECLIPSE_CONFINED:=false}
echo confinedment is enabled? $ECLIPSE_CONFINED

SNAPCRAFT_YAML=$SOURCE/snap/snapcraft.yaml
if $ECLIPSE_CONFINED; then
    SNAPCRAFT_YAML_TEMPLATE=snapcraft.yaml.template_confined
else
    SNAPCRAFT_YAML_TEMPLATE=snapcraft.yaml.template
fi

YGLU_ENABLE_ENV=true pipx run --pip-args "-r requirements.txt" yglu $SNAPCRAFT_YAML_TEMPLATE | tee $SNAPCRAFT_YAML

if [ $? -eq 0 ]; then
    echo written $SNAPCRAFT_YAML for $ECLIPSE_PACKAGE.
else
    echo ERROR see above.
    return 1
fi
