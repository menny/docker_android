# Dockerfile for Android CI with Bazel [![CircleCI](https://circleci.com/gh/menny/docker_android/tree/master.svg?style=svg)](https://circleci.com/gh/menny/docker_android/tree/master)
My general usage (very up-to-date) Docker image for Android with latest Bazelisk 

## Contains:

* All the good staff from the [General Android image](https://github.com/menny/docker_android/blob/master/README.md)
* Go 1.14
* Bazelisk v1.10.1

## Accepting licenses
[Read](https://github.com/menny/docker_android/blob/master/README.md#accepting-licenses) about this at the general Android Docker image.

## Common commands
Build image: `docker build -t menny/android_bazel:latest .`

Pull from Docker Hub: `docker pull menny/android_bazel:latest`