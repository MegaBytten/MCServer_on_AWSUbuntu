#!/bin/bash

# Ensure the script is run with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo."
   exit 1
fi

# Get config.yaml location based on Git Repo name
PROJECT_DIR="/home/ubuntu/MCServer_on_AWSUbuntu"
CONFIG_FILE="${PROJECT_DIR}/config.yaml"

# Getting Ubuntu_path var, because sudo running command resolves $HOME to / (root)
echo "Reading ubuntu_path from config.yaml..."
UBUNTU_PATH=$(yq -r '.ubuntu_path' "$CONFIG_FILE")

echo "creating $UBUNTU_PATH/forge path and downloading forge..."
mkdir $UBUNTU_PATH/forge
wget -O $UBUNTU_PATH/forge/forge-1.21-installer.jar https://maven.minecraftforge.net/net/minecraftforge/forge/1.21.1-52.0.20/forge-1.21.1-52.0.20-installer.jar >/dev/null

echo "installing forge..."
cd $UBUNTU_PATH/forge
java -jar $UBUNTU_PATH/forge/forge-1.21-installer.jar --installServer >/dev/null
cd $UBUNTU_PATH

echo "Moving forge server.jar to $UBUNTU_PATH/mcserver/"
cp $UBUNTU_PATH/forge/forge-1.21.1-52.0.20-shim.jar $UBUNTU_PATH/mcserver