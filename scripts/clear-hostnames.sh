#! /bin/bash

# Input parameters
HARBOR_HOSTNAME=$1
SUDO=$2

# Remove hostname entry from /etc/hosts
IP=$(hostname -I | awk '{print $1}')
HARBOR_NAME_ENTRY="${IP} ${HARBOR_HOSTNAME}"

if grep -q "$HARBOR_NAME_ENTRY" /etc/hosts; then
    echo "$SUDO" | sudo sed -i.bak "/${HARBOR_NAME_ENTRY//\//\\/}/d" /etc/hosts
    echo "Hostname entry removed from /etc/hosts"
else
    echo "Hostname entry does not exist in /etc/hosts"
fi