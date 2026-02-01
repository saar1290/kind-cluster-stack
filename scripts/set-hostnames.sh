#! /bin/bash

# Input parameters
SUDO=$1
HARBOR_HOSTNAME=$2
ARGOCD_HOSTNAME=$3

# Get the IP address of the host machine
IP=$(hostname -I | awk '{print $1}')
HARBOR_NAME_ENTRY="${IP} ${HARBOR_HOSTNAME}"
ARGOCD_NAME_ENTRY="${IP} ${ARGOCD_HOSTNAME}"

# Add hostname entry to /etc/hosts if it doesn't already exist
if grep -q "$HARBOR_NAME_ENTRY" /etc/hosts; then
    echo "Hostname entry already exists in /etc/hosts"
    exit 0
else
    echo "Adding hostname entry to /etc/hosts"
    echo "$SUDO" | sudo -S sh -c "echo '$HARBOR_NAME_ENTRY' >> /etc/hosts" 2>/dev/null
fi

if grep -q "$ARGOCD_NAME_ENTRY" /etc/hosts; then
    echo "ArgoCD hostname entry already exists in /etc/hosts"
    exit 0
else
    echo "Adding ArgoCD hostname entry to /etc/hosts"
    echo "$SUDO" | sudo -S sh -c "echo '$ARGOCD_NAME_ENTRY' >> /etc/hosts" 2>/dev/null
fi