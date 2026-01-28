#!/bin/bash

set -e
 
# Inputs arguments
KIND_STAKE_CERTS_DIR=$1
DOCKER_CERTS_DIR=$2

rm -rf $KIND_STAKE_CERTS_DIR
rm -rf $DOCKER_CERTS_DIR