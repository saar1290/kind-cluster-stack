#!/bin/bash

set -e

# Environment variables
HARBOR_INSTALLATION_DIR="harbor"

# Restart Harbor services
docker compose -f $HARBOR_INSTALLATION_DIR/docker-compose.yml down
docker compose -f $HARBOR_INSTALLATION_DIR/docker-compose.yml up -d
echo "Harbor restarted successfully 👏"