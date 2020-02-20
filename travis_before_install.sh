#!/bin/bash

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
echo '{"registry-mirrors": ["https://mirror.gcr.io"], "mtu": 1460, "experimental": true}' > sudo /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker
