#!/bin/bash

set -e

# Environment variables
HARBOR_DIR="$HOME/harbor/data"
DOCKER_CERTS_DIR="$HOME/.docker/certs.d"
HARBOR_INSTALLATION_DIR="harbor"

# Uninstall Harbor
docker compose -f $HARBOR_INSTALLATION_DIR/docker-compose.yml down
rm -rf $HARBOR_INSTALLATION_DIR
rm -rf $HARBOR_DIR
rm -rf $DOCKER_CERTS_DIR/*
echo "Harbor uninstalled successfully 🧹"