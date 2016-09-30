FROM ubuntu:15.10

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.5.5"
LABEL description="A general use Android docker for CI"

RUN mkdir -p /opt
WORKDIR /opt
COPY tools /opt/tools
RUN chmod +x /opt/tools/start_emulator.sh

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV JAVA_VERSION 1.8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/

# Install java8
 RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java
 RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
 RUN apt-get update && apt-get install -y oracle-java8-installer

# Install Deps and build-essential
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --force-yes ca-certificates nano rsync sudo zip git build-essential wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl psmisc module-init-tools && \
	apt-get clean

# Install Android SDK
RUN wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
	tar --no-same-owner -xzf android-sdk.tgz && \
	rm -f android-sdk.tgz

# Install sdk elements (list from "android list sdk --all --extended")
RUN echo y | android update sdk --all --no-ui --filter platform-tools,build-tools-24.0.3,android-23,android-24,addon-google_apis-google-23,addon-google_apis-google-24,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,extra-google-market_licensing,extra-google-play_billing,extra-google-market_apk_expansion,extra-google-gcm
# Updating the SDK tools, but this will fail, so I'm manually copying the tools to the right folder
RUN echo y | android update sdk --all --no-ui --filter tools && \
	unzip /opt/android-sdk-linux/temp/tools_r25.2.2-linux.zip && \
	rm -rf /opt/android-sdk-linux/tools && \
	mv /opt/tools /opt/android-sdk-linux/ && \
	rm -rf /opt/android-sdk-linux/temp

RUN which adb
RUN which android

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
