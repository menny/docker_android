ARG IMAGE_VERSION
FROM menny/android:${IMAGE_VERSION}

ARG IMAGE_VERSION
ARG NDK_VERSION
LABEL description="A general use Android docker for CI with NDK ${NDK_VERSION}"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

WORKDIR /opt

# Install Android NDK
RUN sdkmanager "ndk;${NDK_VERSION}"
RUN cat /opt/android-sdk-linux/ndk/${NDK_VERSION}/source.properties

# GO to workspace
WORKDIR /opt/workspace
