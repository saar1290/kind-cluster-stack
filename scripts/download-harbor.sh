#!/bin/bash

set -e

# Input arguments
HARBOR_VERSION=$1
HARBOR_INSTALLATION_DIR=$2

# Download Harbor installer
mkdir -p ${HARBOR_INSTALLATION_DIR}
curl -s -L https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer-${HARBOR_VERSION}.tgz -o ${HARBOR_INSTALLATION_DIR}/harbor-online-installer-${HARBOR_VERSION}.tgz
tar xvf ${HARBOR_INSTALLATION_DIR}/harbor-online-installer-${HARBOR_VERSION}.tgz --strip-components=1 -C ${HARBOR_INSTALLATION_DIR}
rm ${HARBOR_INSTALLATION_DIR}/harbor-online-installer-${HARBOR_VERSION}.tgz