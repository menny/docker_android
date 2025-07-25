ARG IMAGE_VERSION
FROM menny/android_bazel:${IMAGE_VERSION}

ARG IMAGE_VERSION
ARG GEMINI_CLI_VERSION=latest

LABEL description="A general use Android docker for local personal development with pnpm, nodejs, and @google/gemini-cli"
LABEL version="${IMAGE_VERSION}-${GEMINI_CLI_VERSION}"
LABEL maintainer="menny@evendanan.net"

WORKDIR /opt

# removing unsupported OpenJDK arg
ENV JAVA_TOOL_OPTIONS=""

# Install dependencies
RUN apt update \
    && apt install -y --allow-remove-essential --allow-change-held-packages \
    zsh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install nodejs and pnpm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y --no-install-recommends nodejs
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -
ENV PNPM_HOME="/root/.local/share/pnpm"
ENV PATH="${PNPM_HOME}:${PATH}"

# Install @google/gemini-cli
RUN pnpm add -g @google/gemini-cli@${GEMINI_CLI_VERSION}

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Set zsh as default shell
SHELL ["/bin/zsh", "-c"]

# GO to workspace
WORKDIR /opt/workspace

COPY entrypoint.sh /opt/workspace/entrypoint.sh
ENTRYPOINT ["/opt/workspace/entrypoint.sh"]
