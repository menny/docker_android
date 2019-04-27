FROM ubuntu:18.04
ARG IMAGE_VERSION

LABEL description="A general use Android docker for CI"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

RUN apt-get update && apt-get install -y software-properties-common
# Install Deps and build-essential
RUN dpkg --add-architecture i386
# and also open-jdk
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install -y locales ca-certificates nano rsync sudo zip git build-essential wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl psmisc module-init-tools python-pip openjdk-8-jdk
RUN update-alternatives --config java
RUN update-alternatives --config javac
RUN apt-get clean

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /opt
WORKDIR /opt
COPY tools /opt/tools
RUN chmod +x /opt/tools/start_emulator.sh

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV JAVA_VERSION 1.8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre

RUN java -version

# Install Android SDK
ADD https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip downloaded_sdk.zip
RUN unzip downloaded_sdk.zip -d /opt/android-sdk-linux
RUN rm -f downloaded_sdk.zip

RUN mkdir ~/.android && touch ~/.android/repositories.cfg
#accepting licenses
RUN yes | sdkmanager --licenses

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager "build-tools;28.0.3"

RUN sdkmanager "platform-tools" "tools"

RUN sdkmanager "platforms;android-28"

RUN sdkmanager "patcher;v4"

# Updating everything again
RUN sdkmanager --update

#accepting licenses
RUN yes | sdkmanager --licenses

RUN sdkmanager --version

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
