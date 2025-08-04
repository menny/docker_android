ARG IMAGE_VERSION
FROM menny/android_bazel:${IMAGE_VERSION}

ARG IMAGE_VERSION
ARG GEMINI_CLI_VERSION=latest
ARG ACTUAL_USER=menny

LABEL description="A general use Android docker for local personal development with pnpm, nodejs, and @google/gemini-cli"
LABEL version="${IMAGE_VERSION}-${GEMINI_CLI_VERSION}"
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

# Install Gemini CLI
RUN . "$NVM_DIR/nvm.sh" && pnpm add -g @google/gemini-cli@${GEMINI_CLI_VERSION}

# Install dependencies
RUN apt update \
    && apt install -y --allow-remove-essential --allow-change-held-packages \
    zsh openssh-server tmux \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd
# Disallow root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
# Explicitly enable password authentication for our user
RUN sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

# Creating to our user
RUN useradd -m -s /bin/zsh ${ACTUAL_USER}
RUN chown -R ${ACTUAL_USER}:${ACTUAL_USER} /opt/workspace

# Switch to the new user to install oh-my-zsh
USER ${ACTUAL_USER}

# Install oh-my-zsh non-interactively
RUN RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN echo "export NVM_DIR=${NVM_DIR}" >> /home/${ACTUAL_USER}/.zshrc && \
    echo "export PNPM_HOME=${PNPM_HOME}" >> /home/${ACTUAL_USER}/.zshrc && \
    echo "export PATH=${PATH}" >> /home/${ACTUAL_USER}/.zshrc && \
    echo "source ${NVM_DIR}/nvm.sh" >> /home/${ACTUAL_USER}/.zshrc && \
    echo "tmux attach-session -t dev-session 2>/dev/null || tmux new-session -s dev-session" >> /home/${ACTUAL_USER}/.zshrc

# Switch back to root for remaining setup
USER root

COPY tmux.conf /etc/tmux.conf
COPY entrypoint.sh /opt/workspace/entrypoint.sh
RUN chmod +x /opt/workspace/entrypoint.sh

WORKDIR /opt/workspace

ENTRYPOINT ["/opt/workspace/entrypoint.sh"]
