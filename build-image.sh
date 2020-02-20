#!/bin/bash

NAME_BUILDER='multibuilder'
NAME_IMAGE='keinos/demo:latest'

docker login || {
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
