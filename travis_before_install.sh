#!/bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
sudo usermod -aG docker $USER

echo '- Docker CLI Plugins:'
tree ~/.docker/cli-plugins/

echo '- Donwload Plugins:'
mkdir -p ~/.docker/cli-plugins/docker-buildx
cd ~/.docker/cli-plugins/docker-buildx && \
curl \
    -O https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.darwin-amd64 \
    -O https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-amd64 \
    -O https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-arm-v6 \
    -O https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-arm-v7 \
    -O https://github.com/docker/buildx/releases/download/v0.3.1/buildx-v0.3.1.linux-arm64
chmod a+x ~/.docker/cli-plugins/docker-buildx

echo '- Installed Plugins:'
tree ~/.docker/cli-plugins/
