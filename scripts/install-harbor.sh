#!/bin/bash

set -e

# Inputs arguments
SUDO=$1
HARBOR_HOSTNAME=$2
HARBOR_PORT=$3
HARBOR_INSTALLATION_DIR=$4
HARBOR_DATA=$5
DOCKER_CERTS_DIR=$6
SSL_CERTS_DIR=$7

# Environment variables
HARBOR_CONFIG="${HARBOR_INSTALLATION_DIR}/harbor.yml"
HARBOR_TMPL="${HARBOR_INSTALLATION_DIR}/harbor.yml.tmpl"
HARBOR_CERT="${SSL_CERTS_DIR}/harbor.crt"
HARBOR_KEY="${SSL_CERTS_DIR}/harbor.key"
HARBOR_CERT_DIR="${HARBOR_DATA}/certs"

# # Run Harbor installation script
echo "Configuring Harbor installation 🛠️"
cp $HARBOR_TMPL $HARBOR_CONFIG
sed -i "s|hostname: .*|hostname: ${HARBOR_HOSTNAME}|g" $HARBOR_CONFIG
sed -i "s|certificate: .*|certificate: ${HARBOR_CERT_DIR}/${HARBOR_HOSTNAME}.crt|g" $HARBOR_CONFIG
sed -i "s|private_key: .*|private_key: ${HARBOR_CERT_DIR}/${HARBOR_HOSTNAME}.key|g" $HARBOR_CONFIG
sed -i "s|# external_url: .*|external_url: https://${HARBOR_HOSTNAME}|g" $HARBOR_CONFIG
sed -i "s|data_volume: .*|data_volume: ${HARBOR_DATA}|g" $HARBOR_CONFIG
sed -i "s|port: 443|port: ${HARBOR_PORT}|g" $HARBOR_CONFIG
sed -i "s|port: 80|port: 8080|g" $HARBOR_CONFIG
echo "Setting up certificates for Harbor 🔐"
mkdir -p $HARBOR_CERT_DIR
cp $HARBOR_CERT $HARBOR_CERT_DIR/${HARBOR_HOSTNAME}.crt
cp $HARBOR_KEY $HARBOR_CERT_DIR/${HARBOR_HOSTNAME}.key
openssl x509 -inform PEM -in $HARBOR_CERT -out $DOCKER_CERTS_DIR/${HARBOR_HOSTNAME}.cert
cp $HARBOR_KEY $DOCKER_CERTS_DIR/${HARBOR_HOSTNAME}.key
echo "Restarting Docker to apply changes 🔄"
echo $SUDO | sudo -S systemctl restart docker
echo "Installing Harbor 🏗️"
echo $SUDO | sudo -S $HARBOR_INSTALLATION_DIR/prepare
chmod +x $HARBOR_INSTALLATION_DIR/install.sh 
echo $SUDO | sudo -S $HARBOR_INSTALLATION_DIR/install.sh --with-trivy
echo "Harbor installation completed successfully ✅"