#! /bin/bash

# Input parameters
HARBOR_INSTALLATION_DIR=$1
SUDO=$2

# Create harbor.service file
cat <<EOF > harbor.service
[Unit]
Description=Harbor Container Registry
Documentation=https://goharbor.io
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/home/saar-lab/harbor
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF
# Move harbor.service to systemd directory and enable the service
echo "$SUDO" | sudo -S mv harbor.service /etc/systemd/system/harbor.service 2>/dev/null
echo "$SUDO" | sudo -S systemctl daemon-reload 2>/dev/null
echo "$SUDO" | sudo -S systemctl enable harbor 2>/dev/null