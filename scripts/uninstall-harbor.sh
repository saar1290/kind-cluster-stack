#!/bin/bash

# Input arguments
HARBOR_INSTALLATION_DIR=$1
SUDO=$2

# Uninstall Harbor
docker compose -f $HARBOR_INSTALLATION_DIR/docker-compose.yml down
echo $SUDO | sudo rm -rf $HARBOR_INSTALLATION_DIR
echo "Harbor uninstalled successfully 🧹"