FROM ubuntu:16.04

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.7.1"
LABEL description="A general use Android docker for CI"

RUN apt-get update && apt-get install -y software-properties-common
# Install Deps and build-essential
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y locales ca-certificates nano rsync sudo zip git build-essential wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl psmisc module-init-tools python-pip && \
	apt-get clean

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /opt
WORKDIR /opt
COPY tools /opt/tools
RUN chmod +x /opt/tools/start_emulator.sh

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV JAVA_VERSION 1.8
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/

# Install java8
 RUN add-apt-repository -y ppa:webupd8team/java
 RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
 RUN apt-get update && apt-get install -y oracle-java8-installer
 RUN apt-get install oracle-java8-set-default

RUN pip install -U pip
RUN pip install awscli

# Install Android SDK
RUN wget --output-document=android-sdk.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
	mkdir /opt/android-sdk-linux && \
	unzip android-sdk.zip -d /opt/android-sdk-linux && \
	rm -f android-sdk.zip

RUN mkdir ~/.android && touch ~/.android/repositories.cfg
#accepting licenses
RUN yes | sdkmanager --licenses

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager "build-tools;26.0.0"

RUN sdkmanager "platform-tools" "tools"

RUN sdkmanager "platforms;android-26" "platforms;android-25" "platforms;android-24" 

RUN sdkmanager "extras;android;m2repository" "extras;google;m2repository"

RUN sdkmanager "extras;google;auto" "extras;google;market_licensing" "extras;google;play_billing" 

RUN sdkmanager "extras;google;google_play_services"

RUN sdkmanager "emulator" "extras;google;simulators"

RUN sdkmanager "add-ons;addon-google_apis-google-24"

RUN sdkmanager "patcher;v4"

# Updating everything again
RUN sdkmanager --update

#accepting licenses
RUN yes | sdkmanager --licenses

RUN which adb

# GO to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
