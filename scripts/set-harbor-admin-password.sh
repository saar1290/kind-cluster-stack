#!/bin/bash

HARBOR_URL=$1
CURRENT_PASSWORD="Harbor12345"
NEW_PASSWORD=$3

# Set Harbor admin password
# Usage: ./set-admin-password.sh <HARBOR_URL> <CURRENT_PASSWORD> <NEW_PASSWORD>
curl -X PUT --user "admin:${CURRENT_PASSWORD}" \
  -H "Content-Type: application/json" \
  "${HARBOR_URL}/api/v2.0/users/1/password" \
  -d '{"old_password": "${CURRENT_PASSWORD}", "new_password": "${NEW_PASSWORD}"}'
