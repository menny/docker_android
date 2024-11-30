#!/bin/bash
set -e

source "$(dirname -- "${BASH_SOURCE[0]}")/shared_tools_versions.sh"

PREVIOUS_SIZE="$(docker manifest inspect menny/${IMAGE_NAME}:latest | jq -r '.config.size + ([.layers[].size] | add)')"

docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} menny/${IMAGE_NAME}:latest
docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} ghcr.io/menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker image tag menny/${IMAGE_NAME}:${IMAGE_VERSION} ghcr.io/menny/${IMAGE_NAME}:latest

docker push menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker push menny/${IMAGE_NAME}:latest
docker push ghcr.io/menny/${IMAGE_NAME}:${IMAGE_VERSION}
docker push ghcr.io/menny/${IMAGE_NAME}:latest

# removing to ensure we're pull the right size
docker rmi menny/${IMAGE_NAME}:latest
CURRENT_SIZE="$(docker manifest inspect menny/${IMAGE_NAME}:latest | jq -r '.config.size + ([.layers[].size] | add)')"

SIZES_MSG="Pushed image 'menny/${IMAGE_NAME}:${IMAGE_VERSION}'. Previous size was ${PREVIOUS_SIZE} and current is ${CURRENT_SIZE}."

echo "$SIZES_MSG"

if [[ -n "$GITHUB_COMMENT_URL" ]]; then
    JSON_DATA=$(jq --null-input --arg body "${SIZE_MESSAGE}" '{ "body": $body }')
    curl -s -X POST \
        $GITHUB_COMMENT_URL \
        -H "Content-Type: application/json" \
        -H "Authorization: token $GITHUB_TOKEN" \
        --data "${JSON_DATA}" > /dev/null
fi
