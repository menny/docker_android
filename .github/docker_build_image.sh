#!/bin/bash
set -e

docker build ${DOCKER_FILE_PATH} --build-arg IMAGE_VERSION="${IMAGE_VERSION}" --build-arg NDK_VERSION="${NDK_VERSION}" --build-arg BAZELISK_VERSION="${BAZELISK_VERSION}" --compress -t "menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw"

SQUASH_MSG=""
if [[ "SQUASH" == "${SQUASH_IMAGE}" ]]; then
    # Squashing
    pip install docker-squash

    echo "** Docker images on machine:"
    docker images
    echo "******"

    echo "** Docker history for menny/${IMAGE_NAME}:${IMAGE_VERSION}:"
    docker history "menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw"
    echo "******"

    COMMITS_COUNT="$(docker history menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw | grep 'buildkit.dockerfile' | wc -l)"
    IMAGE_SIZE_RAW=$(docker inspect -f "{{ .Size }}" "menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw")
    echo "** docker-squash $COMMITS_COUNT layers"
    docker-squash -f "$COMMITS_COUNT" -t "menny/${IMAGE_NAME}:${IMAGE_VERSION}" menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw
    echo "******"

    echo "** Docker images on machine after squash:"
    docker images
    echo "******"
    SQUASH_MSG=" Layers ${COMMITS_COUNT}. Size before squashing: ${IMAGE_SIZE_RAW}" 
else
    echo "Skipping squashing"
    SQUASH_MSG=" No squash."
    docker tag "menny/${IMAGE_NAME}:${IMAGE_VERSION}-raw" "menny/${IMAGE_NAME}:${IMAGE_VERSION}"
fi

IMAGE_SIZE_RAW=$(docker inspect -f "{{ .Size }}" menny/${IMAGE_NAME}:${IMAGE_VERSION})
IMAGE_SIZE=$(echo $IMAGE_SIZE_RAW | numfmt --to=si)
PREVIOUS_SIZE="$(docker manifest inspect menny/${IMAGE_NAME}:latest | jq -r '.config.size + ([.layers[].size] | add)')"
SIZE_MESSAGE="Image size for \`menny/${IMAGE_NAME}:${IMAGE_VERSION}\` is ${IMAGE_SIZE} (or $IMAGE_SIZE_RAW bytes).${SQUASH_MSG} Previous size was ${PREVIOUS_SIZE}."

echo "${SIZE_MESSAGE}"

if [[ -n "$GITHUB_COMMENT_URL" ]]; then
    JSON_DATA=$(jq --null-input --arg body "${SIZE_MESSAGE}" '{ "body": $body }')
    curl -s -X POST \
        $GITHUB_COMMENT_URL \
        -H "Content-Type: application/json" \
        -H "Authorization: token $GITHUB_TOKEN" \
        --data "${JSON_DATA}" > /dev/null
fi
