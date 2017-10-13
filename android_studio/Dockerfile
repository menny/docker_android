FROM menny/android_ndk:1.8.0

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.8.0"
LABEL description="A Docker image with Android build enviroment and Android Studio"

WORKDIR /opt

#ideas taken from https://hub.docker.com/r/dlsniper/docker-intellij/~/dockerfile/

# Install Android Studio
RUN wget --output-document=android-studio-linux.zip --quiet https://dl.google.com/dl/android/studio/ide-zips/3.0.0.15/android-studio-ide-171.4365657-linux.zip && \
  unzip android-studio-linux.zip && \
  rm -f android-studio-linux.zip

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update -qq && \
    apt-get install -qq -y --fix-missing sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 \
        libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip wget && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* 

ENTRYPOINT [ "/opt/android-studio/bin/studio.sh" ]
