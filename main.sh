#!/bin/bash
# set -e
echo "Start build docker image"
IMAGE_NAME="backster/rocket-star"

docker build \
        -t "$IMAGE_NAME:$(git rev-parse HEAD)" \
        -t "$IMAGE_NAME:latest" \
        --build-arg USER_LOGIN="backster" \
        --build-arg PYTHON_VERSION="3.10.13" .

echo "Docker image builded"
docker images

echo "Login to Docker hub"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Start pushing image"

docker push "$IMAGE_NAME:latest" \
&& docker push "$IMAGE_NAME:$(git rev-parse HEAD)" \
&& echo "Image pushed. OK" || echo "Images not pushed"


# curl -s "https://hub.docker.com/v2/repositories/backster/rocket-star/latest/" | jq '.results[] | .name + ": " + (.full_size|tostring) + " bytes"'



