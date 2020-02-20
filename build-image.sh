#!/bin/bash

echo '====================='
echo ' Docker Info'
echo '====================='
echo '- daemon.json: ';
sudo cat /etc/docker/daemon.json
echo '- Docker version:'
docker version
echo '- Docker BuildX version:'
docker buildx version
echo '- Pull linuxkit/binfm:v0.7 (Latest on 2020/02/20)'
docker pull linuxkit/binfmt:v0.7
echo '- cat /proc/sys/fs/binfmt_misc/:'
ls -l /proc/sys/fs/binfmt_misc/

echo '- Login to Docker:'
NAME_BUILDER='multibuilder'
NAME_IMAGE="${DOCKER_USERNAME}/demo:latest"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || {
    echo 'You need to login Docker Cloud/Hub first.'
    exit 1
}

echo '- docker buildx ls'
docker buildx ls

docker buildx ls | grep $NAME_BUILDER
[ $? -ne 0 ] && {
    echo '- Create builder: ' $NAME_BUILDER
    docker buildx create --name $NAME_BUILDER
}
echo '- Start build:'
docker buildx use $NAME_BUILDER && \
docker buildx inspect --bootstrap && \
docker buildx build \
    --platform linux/arm/v6,linux/arm/v7,linux/amd64,linux/arm64 \
    -t $NAME_IMAGE \
    --push . && \
docker buildx imagetools inspect $NAME_IMAGE

docker buildx use default
