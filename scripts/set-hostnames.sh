#! /bin/bash

# Input parameters
HARBOR_HOSTNAME=$1
SUDO=$2
IP=$(hostname -I | awk '{print $1}')
HARBOR_NAME_ENTRY="${IP} ${HARBOR_HOSTNAME}"

# Add hostname entry to /etc/hosts if it doesn't already exist
if grep -q "$HARBOR_NAME_ENTRY" /etc/hosts; then
    echo "Hostname entry already exists in /etc/hosts"
    exit 0
else
    echo "Adding hostname entry to /etc/hosts"
    echo "$SUDO" | sudo -S sh -c "echo '$HARBOR_NAME_ENTRY' >> /etc/hosts" 2>/dev/null
fi
