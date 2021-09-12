ARG IMAGE_VERSION
FROM menny/android_base:${IMAGE_VERSION}

ARG IMAGE_VERSION

LABEL description="A general use Android docker for CI"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager "build-tools;31.0.0"
# Fixing missing dx files
RUN cp /opt/android-sdk-linux/build-tools/31.0.0/d8 /opt/android-sdk-linux/build-tools/31.0.0/dx
RUN cp /opt/android-sdk-linux/build-tools/31.0.0/lib/d8.jar /opt/android-sdk-linux/build-tools/31.0.0/lib/dx.jar

RUN sdkmanager "platforms;android-31"

RUN sdkmanager "patcher;v4"

# Updating everything again
RUN sdkmanager --update

#accepting licenses
RUN yes | sdkmanager --licenses

RUN sdkmanager --version

WORKDIR /opt/workspace