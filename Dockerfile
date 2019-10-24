ARG IMAGE_VERSION
FROM menny/android_base:${IMAGE_VERSION}

ARG IMAGE_VERSION

LABEL description="A general use Android docker for CI"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

# Install sdk elements (list from "sdkmanager --list")
RUN sdkmanager "build-tools;29.0.2"

RUN sdkmanager "platform-tools" "tools"

RUN sdkmanager "platforms;android-29"
RUN sdkmanager "platforms;android-28"

RUN sdkmanager "patcher;v4"

# Updating everything again
RUN sdkmanager --update

#accepting licenses
RUN yes | sdkmanager --licenses

RUN sdkmanager --version

WORKDIR /opt/workspace