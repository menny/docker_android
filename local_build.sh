#!/bin/bash
set -e

# Source the versions.env file to get default values
source .github/versions.env
echo "Will use args: IMAGE_VERSION=${IMAGE_VERSION}, NDK_VERSION=${NDK_VERSION}, BAZELISK_VERSION=${BAZELISK_VERSION}"

function build_image() {
    local image_name="$1"
    local container_engine="docker"

    # Check if podman is available
    if command -v podman >/dev/null 2>&1; then
        container_engine="podman"
    fi

    ${container_engine} build . --build-arg IMAGE_VERSION="${IMAGE_VERSION}" --build-arg NDK_VERSION="${NDK_VERSION}" --build-arg BAZELISK_VERSION="${BAZELISK_VERSION}" --compress -t "menny/${image_name}:${IMAGE_VERSION}"
}

pushd android_base
build_image android_base
popd

build_image android

pushd android_ndk
build_image android_ndk
popd

pushd android_bazel
build_image android_bazel
popd

pushd android_dev_base
build_image android_dev_base
popd

pushd android_dev
build_image android_dev
popd
