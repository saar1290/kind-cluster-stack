#!/bin/bash

set -e

# Input arguments
HARBOR_VERSION=$1

# Download Harbor installer
curl -L https://github.com/goharbor/harbor/releases/download/${HARBOR_VERSION}/harbor-online-installer-${HARBOR_VERSION}.tgz -o harbor-online-installer-${HARBOR_VERSION}.tgz
tar xvf harbor-online-installer-${HARBOR_VERSION}.tgz
rm harbor-online-installer-${HARBOR_VERSION}.tgz