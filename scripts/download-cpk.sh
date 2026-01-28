#! /bin/bash

# Input parameters
CLOUD_PROVIDER_KIND_DIR=$1
git clone https://github.com/kubernetes-sigs/cloud-provider-kind.git ${CLOUD_PROVIDER_KIND_DIR} --depth 1