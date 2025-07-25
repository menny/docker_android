#!/bin/zsh

set -e

# Set default values for git variables
GIT_REPO=${git_repo:-"AnySoftKeyboard/AnySoftKeyboard"}
GIT_BRACH=${git_brach:-"main"}
GIT_PROVIDER=${git_provider:-"github.com"}

# Clone the repository
git clone --branch ${GIT_BRACH} https://${GIT_PROVIDER}/${GIT_REPO}

# Start an interactive zsh shell
exec zsh
