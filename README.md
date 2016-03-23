# Dockerfile for Android CI
My general usage (very up-to-date) Docker image for Android CI

## Contains:

* Ubuntu 15.10, with wget, curl, zip, python
* Java8
* SDK Tools 24.4.1
* Build Tools 23.0.3
* SDK API 23
* Support Library 23.2.1
* Play Services 8.4.0
* ARMv7 System Image API level 23, with Google Services

## Common commands
Build image: `docker build -t menny/android:latest .`

Pull from Docker Hub: `docker pull menny/android:latest`

To run image: `docker run -i -t [image-id] /bin/bash` 

To stop all Docker containers: `docker stop -f $(docker ps -a -q)`

To remove all Docker containers: `docker rm -f $(docker ps -a -q)`

To remove all Docker images: `docker rmi -f $(docker images -q)`
