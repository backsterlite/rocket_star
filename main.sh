#!/bin/bash
set -e
echo "Start build docker image"
docker build \
        -t "rocket-star:$(git rev-parse HEAD)" \
        -t "rocket-star:latest" \
        --build-arg user_login="backster"  .

echo "Docker image builded"
docker images

echo "Login to Docker hub"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

echo "Start pushing image"

docker push "rocket-star:latest"
docker push "rocket-star:$(git rev-parse HEAD)"

echo "Image pushed. OK"


