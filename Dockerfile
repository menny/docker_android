FROM debian:7.9

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.1"
LABEL description="A general use Android docker for CI"

RUN mkdir -p /opt && chown -R root.root /opt 
WORKDIR /opt
COPY tools /opt/tools
RUN chmod +x /opt/tools/android-accept-licenses.sh

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV JAVA_VERSION 1.8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install java8
RUN \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
# Install Deps
  dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect zip git-core build-essential wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
# Cleaning
  apt-get purge -y libx11-data perl-modules && apt-get clean autoclean --auto-remove && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

# Install Android SDK
RUN wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar xzf android-sdk.tgz && rm -f android-sdk.tgz && chown -R root.root android-sdk-linux
# Install sdk elements
# Installing specific packages coming from "android list sdk --all --extended"
RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --force --no-ui --filter platform-tools,build-tools-23.0.3,android-23,addon-google_apis-google-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,sys-img-armeabi-v7a-addon-google_apis-google-23"]

RUN which adb
RUN which android

# Create emulator
#RUN echo "no" | android create avd \
#                --force \
#                --device "Nexus 5" \
#                --name test \
#                --target android-23 \
#                --abi armeabi-v7a \
#                --skin WVGA800 \
#                --sdcard 512M

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
