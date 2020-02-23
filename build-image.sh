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

echo '- Login to Docker:'
NAME_BUILDER='multibuilder'
NAME_IMAGE="${DOCKER_USERNAME}/demo:latest"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || {
    echo 'You need to login Docker Cloud/Hub first.'
    exit 1
}

echo '- docker buildx ls'
LIST_BUILDX_ARC=$(docker buildx ls)
echo $LIST_BUILDX_ARC

docker buildx ls | grep $NAME_BUILDER
[ $? -ne 0 ] && {
    echo '- Create builder: ' $NAME_BUILDER
    docker buildx create --name $NAME_BUILDER
}

echo '- Start build:'
docker buildx use $NAME_BUILDER && \
docker buildx inspect --bootstrap || {
    echo "  FAILED TO USE BUILDER ${NAME_BUILDER}"
    exit 1
}

function build_push_pull_image () {
    echo "- BUILDING ${NAME_PLATFORM}"
    docker buildx build \
        --build-arg NAME_BASE=$NAME_BASE \
        --build-arg VER_ALPINE="v${VERSION_OS}" \
        --platform $NAME_PLATFORM \
        -t "${NAME_IMAGE}:${NAME_TAG}" \
        --push . && \
    echo "  PULLING BACK: ${NAME_IMAGE}:${NAME_TAG}" && \
    docker pull "${NAME_IMAGE}:${NAME_TAG}"

    return $?
}

# Build AMD64
NAME_PLATFORM='linux/amd64'
echo $LIST_BUILDX_ARC | grep $NAME_PLATFORM && {
    NAME_BASE='alpine'
    NAME_TAG='adm64'
    build_push_pull_image
}

# Build ARM64
NAME_PLATFORM='linux/arm64'
echo $LIST_BUILDX_ARC | grep $NAME_PLATFORM && {
    NAME_BASE='alpine'
    NAME_TAG='arm64'
    build_push_pull_image
}

# Build ARMv6
NAME_PLATFORM='linux/arm/v6'
echo $LIST_BUILDX_ARC | grep $NAME_PLATFORM && {
    NAME_BASE='arm32v6/alpine'
    NAME_TAG='armv6'
    build_push_pull_image
}

# Build ARMv7
NAME_PLATFORM='linux/arm/v7'
echo $LIST_BUILDX_ARC | grep $NAME_PLATFORM && {
    NAME_BASE='arm32v7/alpine'
    NAME_TAG='armv7'
    build_push_pull_image
}
