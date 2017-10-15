FROM menny/android:1.8.2

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.8.2"
LABEL description="A general use Android docker for CI with NDK"

WORKDIR /opt

# Install Android NDK
RUN wget --output-document=android-ndk.zip --quiet http://dl.google.com/android/repository/android-ndk-r11c-linux-x86_64.zip && unzip android-ndk.zip && rm -f android-ndk.zip && mv android-ndk-r11c android-ndk-linux

# More environment
ENV ANDROID_NDK /opt/android-ndk-linux
ENV ANDROID_NDK_HOME /opt/android-ndk-linux

# GO to workspace
WORKDIR /opt/workspace
