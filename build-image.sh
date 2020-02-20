#!/bin/bash
sudo cat /etc/docker/daemon.json
docker version
docker version -f '{{.Server.Experimental}}'

echo '{"registry-mirrors": ["https://mirror.gcr.io"], "mtu": 1460, "experimental": true}' > sudo /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl restart docker

docker version
docker version -f '{{.Server.Experimental}}'

NAME_BUILDER='multibuilder'
NAME_IMAGE="${DOCKER_USERNAME}/demo:latest"

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || {
    echo 'You need to login Docker Cloud/Hub first.'
    exit 1
}

echo docker buildx ls

docker buildx ls | grep $NAME_BUILDER
[ $? -ne 0 ] && {
    docker buildx create --name $NAME_BUILDER
}
docker buildx use $NAME_BUILDER && \
docker buildx inspect --bootstrap && \
docker buildx build \
    --platform linux/arm/v6,linux/arm/v7,linux/amd64,linux/arm64 \
    -t $NAME_IMAGE \
    --push . && \
docker buildx imagetools inspect $NAME_IMAGE

docker buildx use default
