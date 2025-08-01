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

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install nodejs and pnpm. Taken from https://nodejs.org/en/download/current
# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source nvm and install Node.js
RUN . "$HOME/.nvm/nvm.sh" && \
    nvm install 24 && \
    nvm use 24 && \
    nvm alias default 24

# Verify Node.js installation
RUN . "$HOME/.nvm/nvm.sh" && \
    node -v && \
    nvm current

# Enable pnpm via corepack
RUN . "$HOME/.nvm/nvm.sh" && corepack enable pnpm

# Verify pnpm installation
RUN . "$HOME/.nvm/nvm.sh" && pnpm -v

# Setup pnpm for global installations and install gemini-cli
RUN . "$HOME/.nvm/nvm.sh" && \
    SHELL=/bin/zsh pnpm setup && \
    export PNPM_HOME="$HOME/.pnpm" && \
    export PATH="$PNPM_HOME:$PATH" && \
    pnpm add -g @google/gemini-cli@${GEMINI_CLI_VERSION}

ENV NVM_DIR="$HOME/.nvm"
ENV PNPM_HOME="$HOME/.pnpm"
ENV PATH=${PNPM_HOME}:${PATH}

# Add nvm to shell profile for future sessions
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc && \
    echo 'export PNPM_HOME="$HOME/.pnpm"' >> ~/.bashrc

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc && \
    echo 'export PNPM_HOME="$HOME/.pnpm"' >> ~/.zshrc

# GO to workspace
WORKDIR /opt/workspace

COPY entrypoint.sh /opt/workspace/entrypoint.sh
ENTRYPOINT ["/opt/workspace/entrypoint.sh"]
