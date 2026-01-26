#!/bin/bash

set -e

# Input arguments
SUDO=$1

# Environment variables
HARBOR_DIR="$HOME/harbor"
HARBOR_INSTALLATION_DIR="harbor"

# Uninstall Harbor
docker compose -f $HARBOR_INSTALLATION_DIR/docker-compose.yml down
rm -rf $HARBOR_INSTALLATION_DIR
echo "Harbor uninstalled successfully 🧹"