#!/bin/bash

if [[ -z "${IMAGE_VERSION}" ]]; then
  export IMAGE_VERSION="1.21.2"
fi
export NDK_VERSION="27.2.12479018"
export BAZELISK_VERSION="v1.24.0"
