#!/bin/bash

# Uninstall old Docker versions
sudo apt-get remove docker docker-engine docker.io containerd runc

# Install packages to allow apt to use a repository over HTTPS
sudo apt-get -y update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# =============================================================================
#  Setup Repository
# =============================================================================
# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Visual verify
sudo apt-key fingerprint 0EBFCD88
echo '- Verify above with: 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88'

# Set up the stable repository
OS="$(lsb_release -cs)"
DOCKER_APT_REPO="https://download.docker.com/linux/ubuntu"
sudo add-apt-repository "deb [arch=amd64] $DOCKER_APT_REPO $OS stable"

# =============================================================================
#  Install Docker Engine - Community
# =============================================================================

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io

echo '- Add user to docker group:'
sudo usermod -aG docker $USER

echo '- Docker version:'
docker version

echo '- Run hello-world:'
docker run hello-world
