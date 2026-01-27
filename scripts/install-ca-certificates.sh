#! /bin/bash

# Input arguments
SUDO=$1
KIND_SSL_CERTS_DIR=$2

# Copy CA certificate to system trust store
if [ ! -f /etc/ssl/certs/ca.pem ]; then
    echo $SUDO | sudo cp ${KIND_SSL_CERTS_DIR}/ca.crt /usr/local/share/ca-certificates/kind-cluster-ca.crt
    echo $SUDO | sudo update-ca-certificates
elif [ -f /etc/ssl/certs/ca.pem ]; then
    echo "CA certificate already exists in the system trust store ❗"
    echo "Replacing it with the new CA certificate 🔄"
    echo $SUDO | sudo rm -f /etc/ssl/certs/ca.pem
    echo $SUDO | sudo cp ${KIND_SSL_CERTS_DIR}/ca.crt /usr/local/share/ca-certificates/kind-cluster-ca.crt
    echo $SUDO | sudo update-ca-certificates
fi