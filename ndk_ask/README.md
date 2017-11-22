# Dockerfile for Android CI with NDK for AnySoftKeyboard [![CircleCI](https://circleci.com/gh/menny/docker_android/tree/master.svg?style=svg)](https://circleci.com/gh/menny/docker_android/tree/master)
AnySoftKeyboard general usage (very up-to-date) Docker image for Android with NDK 

## Contains:

* All the good staff from the [General Android image](https://github.com/menny/docker_android/blob/master/README.md)
* NDK 14b - which supports Android API9+

## Accepting licenses
[Read](https://github.com/menny/docker_android/blob/master/README.md#accepting-licenses) about this at the general Android Docker image.

## Common commands
Build image: `docker build -t menny/android_ndk_ask:latest .`

Pull from Docker Hub: `docker pull menny/android_ndk_ask:latest`