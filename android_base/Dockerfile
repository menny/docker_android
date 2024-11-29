FROM ubuntu:jammy@sha256:f470988096c4d77efac9740a1b6700823681af518a17fad30111430b95dfbffa
ARG IMAGE_VERSION

LABEL description="A general use Android docker for CI"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

# disable interactive functions
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=dumb

# Install Deps and build-essential
RUN apt-get update \
    && apt-get install -y --allow-remove-essential --allow-change-held-packages \
      locales software-properties-common ca-certificates build-essential zlib1g-dev \
      pkg-config file \
      python3 python3-pip python3-lxml python3-yaml libxml2-utils yamllint \
      wget curl nano rsync sudo zip psmisc rsyslog jq unzip \
      imagemagick \
      java-common \
    && apt-get clean
# this is required for the latest git (ubuntu's official git is quite old)
RUN add-apt-repository ppa:git-core/ppa -y \
    && apt-get install -y --allow-remove-essential --allow-change-held-packages git \
    && apt-get clean

RUN touch /var/log/kern.log ; chown syslog:adm /var/log/kern.log

RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN mkdir -p /opt
WORKDIR /opt
COPY tools /opt/tools
RUN chmod +x /opt/tools/start_emulator.sh

# Setup environment
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

# Setup Java
RUN curl https://corretto.aws/downloads/resources/17.0.10.8.1/java-17-amazon-corretto-jdk_17.0.10.8-1_amd64.deb -o jdk-corretto.deb \
    && dpkg --install jdk-corretto.deb \
    && rm jdk-corretto.deb

RUN java -version

# Install Android SDK
RUN curl https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -o downloaded_sdk.zip \
    && mkdir -p /opt/android-sdk-linux/cmdline-tools \
    && unzip downloaded_sdk.zip -d /opt/android-sdk-linux/cmdline-tools \
    && rm -f downloaded_sdk.zip \
    && mv /opt/android-sdk-linux/cmdline-tools/cmdline-tools /opt/android-sdk-linux/cmdline-tools/latest

#accepting licenses
RUN yes | sdkmanager --licenses

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager --list

RUN sdkmanager "cmdline-tools;16.0"
RUN sdkmanager "platform-tools"

#accepting licenses
RUN yes | sdkmanager --licenses

RUN sdkmanager --version

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
