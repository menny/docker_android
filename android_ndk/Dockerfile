ARG IMAGE_VERSION
FROM menny/android:${IMAGE_VERSION}

ARG IMAGE_VERSION
ARG NDK_VERSION
LABEL description="A general use Android docker for CI with NDK ${NDK_VERSION}"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

WORKDIR /opt

# Install Android NDK
ADD https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip /opt/android-ndk.zip
RUN unzip android-ndk.zip -d /opt/ndks
RUN rm -f unzip android-ndk.zip
RUN cat /opt/ndks/android-ndk-${NDK_VERSION}/source.properties

# More environment
ENV ANDROID_NDK /opt/ndks/android-ndk-${NDK_VERSION}
ENV ANDROID_NDK_HOME /opt/ndks/android-ndk-${NDK_VERSION}

# GO to workspace
WORKDIR /opt/workspace
