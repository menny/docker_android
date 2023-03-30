#!/bin/bash
set -e

docker build ${DOCKER_FILE_PATH} --build-arg IMAGE_VERSION="${IMAGE_VERSION}" --build-arg NDK_VERSION="${NDK_VERSION}" --build-arg BAZELISK_VERSION="${BAZELISK_VERSION}" --compress -t "menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw"

# Squashing
pip install docker-squash

echo "** Docker images on machine:"
docker images
echo "******"

echo "** Docker history for menny/${IMAGE_NAME}:${IMAGE_VERSION}:"
docker history "menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw"
echo "******"

INITAL_COMMIT="$(docker history -q menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw | grep -v missing | tail -n 1)"
echo "** docker-squash all the way to initial commit $INITAL_COMMIT"
docker-squash -f "$INITAL_COMMIT" -t "menny/${IMAGE_NAME}:${IMAGE_VERSION}" menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw
echo "******"

echo "** Docker images on machine after squash:"
docker images
echo "******"

if [[ -n "$GITHUB_COMMENT_URL" ]]; then
    IMAGE_SIZE_RAW=$(docker inspect -f "{{ .Size }}" menny/${IMAGE_NAME}:${IMAGE_VERSION})
    IMAGE_SIZE=$(echo $IMAGE_SIZE_RAW | numfmt --to=si)
    JSON_DATA=$(jq --null-input --arg body "Image size for \`menny/${IMAGE_NAME}:${IMAGE_VERSION}\` is ${IMAGE_SIZE} (or $IMAGE_SIZE_RAW bytes)." '{ "body": $body }')
    curl -s -X POST \
        $GITHUB_COMMENT_URL \
        -H "Content-Type: application/json" \
        -H "Authorization: token $GITHUB_TOKEN" \
        --data "${JSON_DATA}" > /dev/null
fi
