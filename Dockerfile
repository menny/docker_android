ARG IMAGE_VERSION
FROM menny/android_base:${IMAGE_VERSION}

ARG IMAGE_VERSION

LABEL description="A general use Android docker for CI"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager "build-tools;35.0.0"

RUN sdkmanager "platforms;android-35"

#accepting licenses
RUN yes | sdkmanager --licenses

RUN sdkmanager --version

WORKDIR /opt/workspace