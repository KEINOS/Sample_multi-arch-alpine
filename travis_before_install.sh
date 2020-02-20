#!/bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
OS="$(lsb_release -cs)"
DOCKER_APT_REPO="https://download.docker.com/linux/ubuntu"
sudo add-apt-repository "deb [arch=amd64] $DOCKER_APT_REPO $OS stable"
sudo apt-get update
sudo apt-get -y install \
    qemu-user-static \
    binfmt-support
sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce

echo '- Add user to docker group:'
sudo usermod -aG docker $USER

echo '- Check file system mount:'
ls /proc/sys/fs/binfmt_misc/
