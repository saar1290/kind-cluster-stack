#!/bin/bash

set -e

# Environment variables
HARBOR_CONFIG="harbor/harbor.yml"
HARBOR_TMPL="harbor/harbor.yml.tmpl"
HARBOR_CERT="ssl/harbor.crt"
HARBOR_KEY="ssl/harbor.key"
HARBOR_INSTALLATION_DIR="harbor"
HARBOR_CERT_DIR="$HOME/harbor/data/certs"
HARBOR_DATA="$HOME/harbor"

# Inputs arguments
HARBOR_HOSTNAME=$1
DOCKER_CERTS_DIR=$2

# # Run Harbor installation script
cp $HARBOR_TMPL $HARBOR_CONFIG
sed -i "s|hostname: .*|hostname: ${HARBOR_HOSTNAME}|g" $HARBOR_CONFIG
sed -i "s|certificate: .*|certificate: ${HARBOR_CERT_DIR}/${HARBOR_HOSTNAME}.crt|g" $HARBOR_CONFIG
sed -i "s|private_key: .*|private_key: ${HARBOR_CERT_DIR}/${HARBOR_HOSTNAME}.key|g" $HARBOR_CONFIG
sed -i "s|# external_url: .*|external_url: https://${HARBOR_HOSTNAME}|g" $HARBOR_CONFIG
sed -i "s|data_volume: .*|data_volume: ${HARBOR_DATA}|g" $HARBOR_CONFIG
mkdir -p $HARBOR_CERT_DIR
cp $HARBOR_CERT $HARBOR_CERT_DIR/${HARBOR_HOSTNAME}.crt
cp $HARBOR_KEY $HARBOR_CERT_DIR/${HARBOR_HOSTNAME}.key
openssl x509 -inform PEM -in $HARBOR_CERT -out $DOCKER_CERTS_DIR/${HARBOR_HOSTNAME}.cert
cp $HARBOR_KEY $DOCKER_CERTS_DIR/${HARBOR_HOSTNAME}.key
cd $HARBOR_INSTALLATION_DIR && ./prepare
cd .. && chmod +x $HARBOR_INSTALLATION_DIR/install.sh && $HARBOR_INSTALLATION_DIR/install.sh --with-trivy