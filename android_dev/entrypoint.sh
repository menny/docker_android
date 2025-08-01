#!/bin/zsh

set -e

# Clone the repository
git clone --branch "${GIT_BRANCH:-"main"}" "https://${GIT_PROVIDER:-"github.com"}/${GIT_REPO:-"AnySoftKeyboard/AnySoftKeyboard"}"

# Start an interactive zsh shell
exec zsh
