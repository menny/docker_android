#!/bin/bash

set -e

IMAGE_VERSION="$1"
NDK_VERSION="$2"

if [[ -z "$IMAGE_VERSION" ]]; then
    echo "Provide image version as the first argument"
    exit 1
fi
if [[ -z "$NDK_VERSION" ]]; then
    echo "Provide NDK_VERSION version as the second argument"
    exit 1
fi
if [[ -z "$IMAGE_VERSION" ]]; then
    echo "Provide image version as the first argument"
    exit 1
fi

function build_image() {
    local image_name="$1"
    docker build . --build-arg IMAGE_VERSION="${IMAGE_VERSION}" --build-arg NDK_VERSION="${NDK_VERSION}" --compress -t "menny/${image_name}:${IMAGE_VERSION}"
}

pushd android_base
build_image android_base
popd

build_image android

pushd android_ndk
build_image android_ndk
popd
