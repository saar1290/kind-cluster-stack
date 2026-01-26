#!/bin/bash

# Inputs arguments
DOCKER_CERTS_DIR=$1

rm -rf ssl/*
rm -rf $DOCKER_CERTS_DIR