#!/bin/zsh

set -e

# Clone the repository
git clone --branch "${GIT_BRANCH:-"main"}" "https://${GIT_PROVIDER:-"github.com"}/${GIT_REPO:-"AnySoftKeyboard/AnySoftKeyboard"}"

if ! id "sshd" &>/dev/null; then
    useradd -r -s /bin/false -d /var/run/sshd sshd
fi

if [ ! -z "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
else
    echo "Warning: ROOT_PASSWORD environment variable not set"
    echo "root:password" | chpasswd
fi

chsh -s /bin/zsh root

# Start the ssh server
echo "Starting ssh daemon"
exec /usr/sbin/sshd -D
