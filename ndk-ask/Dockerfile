FROM menny/android:1.9.0

MAINTAINER Menny Even-Danan "menny@evendanan.net"
LABEL version="1.9.0-14b"
LABEL description="A general use Android docker for CI with NDK r14b"

WORKDIR /opt

# Install Android NDK
RUN wget --output-document=android-ndk.zip --quiet https://dl.google.com/android/repository/android-ndk-r14b-linux-x86_64.zip && unzip android-ndk.zip && rm -f android-ndk.zip && mv android-ndk-r14b android-ndk-linux

# More environment
ENV ANDROID_NDK /opt/android-ndk-linux
ENV ANDROID_NDK_HOME /opt/android-ndk-linux

# GO to workspace
WORKDIR /opt/workspace
