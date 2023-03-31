#!/bin/bash
set -e

docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} menny/${IMAGE_NAME}:latest
docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} ghcr.io/menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} ghcr.io/menny/${IMAGE_NAME}:latest

docker push menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker push menny/${IMAGE_NAME}:latest
docker push ghcr.io/menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker push ghcr.io/menny/${IMAGE_NAME}:latest
