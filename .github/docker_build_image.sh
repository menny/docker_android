#!/bin/bash
docker build ${DOCKER_FILE_PATH} --build-arg IMAGE_VERSION="${IMAGE_VERSION}" --build-arg NDK_VERSION="${NDK_VERSION}" --build-arg BAZELISK_VERSION="${BAZELISK_VERSION}" --compress -t menny/"${IMAGE_NAME}":"${IMAGE_VERSION}"
