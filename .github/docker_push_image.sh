#!/bin/bash
docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
docker push menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} menny/${IMAGE_NAME}:latest
docker push menny/${IMAGE_NAME}:latest
