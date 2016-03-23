FROM ubuntu:15.10

MAINTAINER Menny Even-Danan "menny@evendanan.net"

# Install java8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect zip git wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl

# Ugrade system
RUN apt-get upgrade -y

# Install Android SDK
RUN wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar xzf android-sdk.tgz && rm -f android-sdk.tgz && chown -R root.root android-sdk-linux

# Setup environment
ENV ANDROID_HOME /android-sdk-linux
ENV JAVA_VERSION 1.8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

RUN which android

# Install sdk elements
COPY tools /tools
RUN chmod +x /tools/android-accept-licenses.sh
# Installing specific packages coming from "android list sdk --all --extended"
RUN ["/tools/android-accept-licenses.sh", "android update sdk --all --force --no-ui --filter platform-tools,build-tools-23.0.3,android-23,addon-google_apis-google-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,sys-img-armeabi-v7a-addon-google_apis-google-23"]

RUN which adb
RUN which android

# Install Android NDK
RUN wget --output-document=android-ndk.zip --quiet http://dl.google.com/android/repository/android-ndk-r11b-linux-x86_64.zip && unzip android-ndk.zip && rm -f android-ndk.zip && chown -R root.root android-ndk-r11b && mv android-ndk-r11b android-ndk-linux

# More environment
ENV ANDROID_NDK /android-ndk-linux
ENV ANDROID_NDK_HOME /android-ndk-linux

# Create emulator
#RUN echo "no" | android create avd \
#                --force \
#                --device "Nexus 5" \
#                --name test \
#                --target android-23 \
#                --abi armeabi-v7a \
#                --skin WVGA800 \
#                --sdcard 512M

# Cleaning
RUN apt-get clean

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace