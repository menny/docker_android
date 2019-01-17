ARG IMAGE_VERSION
FROM menny/android:${IMAGE_VERSION}

ARG IMAGE_VERSION
ARG BAZEL_VERSION

LABEL description="A general use Android docker for CI with Bazel version ${BAZEL_VERSION}"
LABEL version="${IMAGE_VERSION}-${BAZEL_VERSION}"
LABEL maintainer="menny@evendanan.net"


WORKDIR /opt

# Install Bazel
RUN sudo apt-get install -y pkg-config zip g++ zlib1g-dev unzip python
ADD https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh /opt/
RUN chmod +x /opt/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
RUN ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh --user
RUN rm -f /opt/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
ENV PATH ${PATH}:/root/bin
# this will ensure we installed correctly, and will extract the installation
RUN bazel version
# GO to workspace
WORKDIR /opt/workspace
