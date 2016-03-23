# Dockerfile for Android CI with NDK
My general usage (very up-to-date) Docker image for Android with NDK CI 

##Contains:

* All the good staff from the [General Android image](https://github.com/menny/docker_android/blob/master/README.md)
* NDK 11b

## Common commands
Build image: `docker build -t menny/android_ndk:latest .`

Pull from Docker Hub: `docker pull menny/android_ndk:latest`

To run image: `docker run -i -t [image-id] /bin/bash` 

To stop all Docker containers: `docker stop -f $(docker ps -a -q)`

To remove all Docker containers: `docker rm -f $(docker ps -a -q)`

To remove all Docker images: `docker rmi -f $(docker images -q)`
