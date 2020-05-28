ARG IMAGE_VERSION
FROM menny/android:${IMAGE_VERSION}

ARG IMAGE_VERSION
ARG BAZELISK_VERSION

LABEL description="A general use Android docker for CI with Bazelisk version ${BAZELISK_VERSION}"
LABEL version="${IMAGE_VERSION}-${BAZELISK_VERSION}"
LABEL maintainer="menny@evendanan.net"

WORKDIR /opt

# removing unsupported OpenJDK arg
ENV JAVA_TOOL_OPTIONS=""

# Install Go (required by Bazelisk)
RUN add-apt-repository ppa:longsleep/golang-backports
RUN apt update
RUN apt install -y --allow-remove-essential --allow-change-held-packages golang-go

# Install bazelisk
RUN mkdir /opt/bazelisk
ADD https://github.com/bazelbuild/bazelisk/releases/download/${BAZELISK_VERSION}/bazelisk-linux-amd64 /opt/bazelisk/
RUN mv /opt/bazelisk/bazelisk-linux-amd64 /opt/bazelisk/bazelisk
RUN chmod +x /opt/bazelisk/bazelisk
RUN /opt/bazelisk/bazelisk version
RUN ln -s /opt/bazelisk/bazelisk /opt/bazelisk/bazel
ENV PATH ${PATH}:/opt/bazelisk
# this will ensure we installed correctly, and will extract the installation
RUN bazelisk version
RUN bazel version
# GO to workspace
WORKDIR /opt/workspace
