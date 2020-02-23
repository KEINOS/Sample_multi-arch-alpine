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

echo '==============================================================================='

curl -fsSL get.docker.com -o get-docker.sh && \
sh get-docker.sh && \
sudo gpasswd -a $USER docker && \
sudo docker run hello-world && \
rm -f get-docker.sh

# =============================================================================
echo '[DONE]========================================================================='
