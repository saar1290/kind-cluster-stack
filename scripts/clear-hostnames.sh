#! /bin/bash

# Input parameters
SUDO=$1
HARBOR_HOSTNAME=$2
ARGOCD_HOSTNAME=$3

# Remove hostname entry from /etc/hosts
IP=$(hostname -I | awk '{print $1}')
HARBOR_NAME_ENTRY="${IP} ${HARBOR_HOSTNAME}"
ARGOCD_NAME_ENTRY="${IP} ${ARGOCD_HOSTNAME}"

if grep -q "$HARBOR_NAME_ENTRY" /etc/hosts; then
    echo "$SUDO" | sudo -S sed -i.bak "/${HARBOR_NAME_ENTRY//\//\\/}/d" /etc/hosts
    echo "Hostname entry removed from /etc/hosts"
else
    echo "Hostname entry does not exist in /etc/hosts"
fi

if grep -q "$ARGOCD_NAME_ENTRY" /etc/hosts; then
    echo "$SUDO" | sudo -S sed -i.bak "/${ARGOCD_NAME_ENTRY//\//\\/}/d" /etc/hosts
    echo "ArgoCD hostname entry removed from /etc/hosts"
else
    echo "ArgoCD hostname entry does not exist in /etc/hosts"
fi