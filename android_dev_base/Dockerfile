ARG IMAGE_VERSION
FROM menny/android_bazel:${IMAGE_VERSION}

ARG IMAGE_VERSION

LABEL description="A general use Android docker for local personal development with pnpm, nodejs, and @google/gemini-cli"
LABEL version="${IMAGE_VERSION}"
LABEL maintainer="menny@evendanan.net"

# Install nodejs and pnpm. Taken from https://nodejs.org/en/download/current
ENV NVM_DIR=/opt/nvm
RUN mkdir -p ${NVM_DIR}
# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

ENV PNPM_HOME="/opt/.pnpm"
ENV PATH=${PNPM_HOME}:${PATH}

# Source nvm and install Node.js
RUN . "$NVM_DIR/nvm.sh" && \
    nvm install 24 && \
    nvm use 24 && \
    nvm alias default 24

# Verify Node.js installation
RUN . "$NVM_DIR/nvm.sh" && \
    node -v && \
    nvm current

# Enable pnpm via corepack
RUN . "$NVM_DIR/nvm.sh" && corepack enable pnpm

# Verify pnpm installation
RUN . "$NVM_DIR/nvm.sh" && pnpm -v && SHELL=/bin/zsh pnpm setup

# Install Gemini CLI and Claude Code
RUN . "$NVM_DIR/nvm.sh" && pnpm add -g @google/gemini-cli@latest @anthropic-ai/claude-code@latest

# Install dependencies
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install -y --allow-remove-essential --allow-change-held-packages \
    zsh tmux gh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/workspace
