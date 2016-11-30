# Dockerfile for Android CI
My general usage (very up-to-date) Docker image for Android CI

## Contains:

* Ubuntu 15.10, with wget, curl, zip, python, git, make, gcc (and other build-essential)
* Java8
* Platform tools 25.0.1
* SDK Tools 25.2.3
* Build Tools 25.0.1
* SDK API 24 and 25
* Support Library 25.0.1
* Play Services and Firebase up to 10.0.1
* And more (gcm, licensing, billing, apk exp., etc.).
* `/opt/tools/start_emulator.sh` script which can download and start an emulator.


## Common commands
Build image: `docker build -t menny/android:1.6.0 .`

Pull from Docker Hub: `docker pull menny/android:1.6.0`

To run image (and attach to STDIN/STDOUT): `docker run -i -t menny/android:1.6.0` 

## General Docker commands:
To stop *all* Docker containers: `docker stop $(docker ps -a -q)`

To remove *all* Docker containers: `docker rm -f $(docker ps -a -q)`

To remove *all* Docker images: `docker rmi -f $(docker images -q)`
