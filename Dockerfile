FROM ubuntu:15.10

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.2.3"
LABEL description="A general use Android docker for CI"

RUN mkdir -p /opt && chown -R root.root /opt 
WORKDIR /opt
COPY tools /opt/tools
RUN chmod +x /opt/tools/android-accept-licenses.sh && \
	chmod +x /opt/tools/start_emulator.sh

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV JAVA_VERSION 1.8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install java8
RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get update && apt-get install -y oracle-java8-installer
# Install Deps and build-essential
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y --force-yes expect zip git build-essential wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl
  
# Install Android SDK
RUN wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && tar xzf android-sdk.tgz && rm -f android-sdk.tgz && chown -R root.root android-sdk-linux

# Install sdk elements (list from "android list sdk --all --extended")
RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --force --no-ui --filter tools,platform-tools,build-tools-23.0.3,android-23,addon-google_apis-google-23,extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,extra-google-market_licensing,extra-google-play_billing,extra-google-market_apk_expansion,extra-google-gcm"]

RUN which adb
RUN which android

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
