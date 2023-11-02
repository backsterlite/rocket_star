# Scripts describes

## .circleci/config.yaml
    In this file we write circleci configurations
`version: 2.1` - version of circleci 

### Section with describe what we do
```
jobs: - jobs section
  build: - name of first job
    docker: - section say that job run in docker container
      - image: circleci/python:3.7 - image that runing
    resource_class: small - instruction say use small virtual mashine
    steps: - Start section with steps
      - checkout pre configure for current branch 
      - setup_remote_docker: - use some version of docker
          version: 20.10.18 - docker version
      - run: section for execute
          name: Run my script - describe execute
          command: | - commands for run
            echo "This is my simple script!"
            # Тут можна додати додаткові команди, наприклад:
            ./main.sh
```
### Section with describe how we do

```
workflows: - start workflow section
  app_build_and_test: - section name
    jobs: - start section with jobs
      - build - name of job
      - test: - name of job
          filters: - run with contion
            branches: - say run on some branches
              only: master - only on master branch
          requires: - run current job after some job
            - build - job require passed
```
## Dockerfile
    File for configure docker image that we use

```
ARG PYTHON_VERSION - declare variable that we passed in cli command
FROM python:${PYTHON_VERSION} - initialise our image from python image


ENV PIP_ROOT_USER_ACTION=ignore - set environment variable that allow use python as root

ARG USER_LOGIN - declare variable that we passed in cli command

ENV USER_LOGIN=${USER_LOGIN} - set environment variable

RUN echo ${PYTHON_VERSION} - print in stdout variable value
RUN apt-get update \ - run comand for install some packages
    && apt-get install -y htop \
    make \
    git

RUN python -m pip install Flask - install python package

WORKDIR /backster/app - set default path in container

COPY . /backster/app/ - copy files in container

CMD ["python", "./main.py"] - run some command after create container
```

## main.sh
    File where we describe all processes about build and deploy image

```
#!/bin/bash - declare standart path to bash
set -e     - instraction for fail script when error
echo "Start build docker image"
IMAGE_NAME="backster/rocket-star" - set variable with image name

docker build \ - command for build docker image
        -t "$IMAGE_NAME:$(git rev-parse HEAD)" \ - set tag with last commit hash
        -t "$IMAGE_NAME:latest" \ - set another tag name
        --build-arg USER_LOGIN="backster" \ - set argument that used in Dockerfile
        --build-arg PYTHON_VERSION="3.10.13" .  - set argument that used in Dockerfile

echo "Docker image builded"
docker images - show all local docker images

echo "Login to Docker hub"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin - login to docker hub with credentials from ENV

echo "Start pushing image"

docker push "$IMAGE_NAME:latest" \
&& docker push "$IMAGE_NAME:$(git rev-parse HEAD)" \
&& echo "Image pushed. OK" || exit 1 - pushed images to docker hub and exit whith error code if fail
```

## main.py
    File for create simple web server and page with standart "Hello World"