# Dockerfile for Android CI
My general usage (very up-to-date) Docker image for Android CI

## Contains:

* Based on `ubuntu:17.04`
* with wget, curl, zip, python, pip, git, make, gcc (and other build-essential)
* Java8
* Platform tools 26.0.2
* SDK Tools 26.0.2
* Build Tools 26.0.2
* SDK API 26
* Support, Google and Play-Services repositories

## Accepting licenses
Getting an error when building Android with this Docker image? Something like this:
```
FAILURE: Build failed with an exception.

* What went wrong:
A problem occurred configuring project ':app'.
> You have not accepted the license agreements of the following SDK components:
  [Android SDK Platform 25, Android SDK Build-Tools 25.0.1].
  Before building your project, you need to accept the license agreements and complete the installation of the missing components using the Android Studio SDK Manager.
  Alternatively, to learn how to transfer the license agreements from one workstation to another, go to http://d.android.com/r/studio-ui/export-licenses.html
```
You'll need to create licenses folder with license files under `${ANDROID_HOME}`. Accept the licenses on you local machine
then create the same files inside the Docker image, using your CI script. Something like this:
```
echo -e "8933bad161af4178b1185d1a37fbf41ea5269c55\c" > ${ANDROID_HOME}/licenses/android-sdk-license
echo -e "79120722343a6f314e0719f863036c702b0e6b2a\n84831b9409646a918e30573bab4c9c91346d8abd\c" > ${ANDROID_HOME}/licenses/android-sdk-preview-license
echo -e "8403addf88ab4874007e1c1e80a0025bf2550a37\c" > ${ANDROID_HOME}/licenses/intel-android-sysimage-license
```
Also, due to a known [bug](https://code.google.com/p/android/issues/detail?id=2123090), you'll need to run `gradle` twice. So:
```
./gradlew dependencies || true
./gradlew clean
```    

## Common commands
Build image: `docker build -t menny/android:latest .`

Pull from Docker Hub: `docker pull menny/android:latest`

To run image (and attach to STDIN/STDOUT): `docker run -i -t menny/android:latest`

## General Docker commands:
To stop *all* Docker containers: `docker stop $(docker ps -a -q)`

To remove *all* Docker containers: `docker rm -f $(docker ps -a -q)`

To remove *all* Docker images: `docker rmi -f $(docker images -q)`
