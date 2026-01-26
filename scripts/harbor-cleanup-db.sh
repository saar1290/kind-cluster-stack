#!/bin/bash

# Input arguments
HARBOR_DATA_LOCATION=$1
SUDO=$2

sleep 10
sudo rm -rf $HARBOR_DATA_LOCATION
echo "Harbor cleanup data stores successfully 🧹"