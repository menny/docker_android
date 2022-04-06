FROM adoptopenjdk/openjdk11:jdk-11.0.12_7-ubuntu-slim
ARG IMAGE_VERSION

LABEL description="A general use Android docker for CI"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

# Install Deps and build-essential
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y --allow-remove-essential --allow-change-held-packages \
    software-properties-common locales ca-certificates build-essential zlib1g-dev \
    libc6-i386 lib32stdc++6 lib32gcc1 lib32z1 pkg-config g++ \
    python python3 python3-pip python-lxml python-yaml libxml2-utils \
    wget curl nano rsync sudo zip psmisc rsyslog jq unzip
# this is required for the latest git (ubuntu's official git is quite old)
RUN add-apt-repository ppa:git-core/ppa -y
RUN apt-get install -y --allow-remove-essential --allow-change-held-packages git

RUN apt-get clean

RUN touch /var/log/kern.log ; chown syslog:adm /var/log/kern.log

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
ENV PATH ${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

RUN java -version

# Install Android SDK
ADD https://dl.google.com/android/repository/commandlinetools-linux-8092744_latest.zip downloaded_sdk.zip
RUN mkdir -p /opt/android-sdk-linux/cmdline-tools
RUN unzip downloaded_sdk.zip -d /opt/android-sdk-linux/cmdline-tools
RUN rm -f downloaded_sdk.zip
RUN mv /opt/android-sdk-linux/cmdline-tools/cmdline-tools /opt/android-sdk-linux/cmdline-tools/latest

#accepting licenses
RUN yes | sdkmanager --licenses

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager "cmdline-tools;6.0"
RUN sdkmanager "platform-tools"
RUN sdkmanager "patcher;v4"

# Updating everything again
RUN sdkmanager --update

#accepting licenses
RUN yes | sdkmanager --licenses

RUN sdkmanager --version

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
