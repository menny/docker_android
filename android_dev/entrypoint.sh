#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Use environment variables passed to the container, with sensible defaults.
GIT_PROVIDER=${GIT_PROVIDER:-"github.com"}
GIT_REPO=${GIT_REPO:-"AnySoftKeyboard/AnySoftKeyboard"}
GIT_BRANCH=${GIT_BRANCH:-"main"}
# The user is defined in the Dockerfile ARG, but we need it here too.
# We'll pass it as an environment variable to the container.
ACTUAL_USER=${ACTUAL_USER:-"menny"}

WORKSPACE_DIR="/opt/workspace"
# Extract the repository name to use as the folder name
REPO_NAME=$(basename "${GIT_REPO}")
CLONE_DIR="${WORKSPACE_DIR}/${REPO_NAME}"

# --- 1. Clone Git Repository ---
echo "Cloning repository '${GIT_REPO}' from branch '${GIT_BRANCH}'..."

# Clone the repository into a specific subdirectory within the workspace
git clone --branch "${GIT_BRANCH}" "https://${GIT_PROVIDER}/${GIT_REPO}" "${CLONE_DIR}"
# The user should be in the clone folder right after login
echo "cd $CLONE_DIR" >> "/home/${ACTUAL_USER}/.zshrc"

# --- 2. Set Permissions ---

# Function to fix ownership and permissions for a directory
copy_fix_dir_permissions() {
    local dir_path=$1
    echo "Fixing permissions for ${dir_path}..."
    mkdir -p "${dir_path}"
    local original_path="${dir_path}_original"
    cp -a "${original_path}/." "${dir_path}/"
    chown -R ${ACTUAL_USER}:${ACTUAL_USER} "${dir_path}"
    find "${dir_path}" -type d -exec chmod 700 {} +
    find "${dir_path}" -type f -exec chmod 600 {} +
}

# Function to fix ownership for a file
copy_fix_file_owner() {
    local file_path=$1
    echo "Fixing ownership for ${file_path}..."
    mkdir -p "dirname(${file_path})"
    local original_path="${file_path}_original"
    cp "${original_path}" "${file_path}"
    chown ${ACTUAL_USER}:${ACTUAL_USER} "${file_path}"
}

echo "Setting permissions for user '${ACTUAL_USER}' on '${CLONE_DIR}'..."
# Give the user ownership of the newly cloned repository folder
chown -R ${ACTUAL_USER}:${ACTUAL_USER} "${CLONE_DIR}"

# Fix permissions for mounted directories and files
copy_fix_dir_permissions "/home/${ACTUAL_USER}/.ssh"
copy_fix_dir_permissions "/home/${ACTUAL_USER}/.gnupg"
copy_fix_dir_permissions "/home/${ACTUAL_USER}/.gemini"
copy_fix_file_owner "/home/${ACTUAL_USER}/.gitconfig"

# --- 3. Set User Password ---
# Check if the ACTUAL_PASSWORD environment variable is provided
if [ -n "$ACTUAL_PASSWORD" ]; then
    echo "Setting password for user '${ACTUAL_USER}'..."
    # Use chpasswd to set the password from the environment variable
    echo "${ACTUAL_USER}:${ACTUAL_PASSWORD}" | chpasswd
    echo "Password has been set."
else
    # Warn the user if the password is not set
    echo "ERROR: No 'ACTUAL_PASSWORD' environment variable found."
    echo "User '${ACTUAL_USER}' will not have a password set, and password-based SSH may fail."
    exit 1
fi

# --- 4. Start SSH Server ---
echo "Starting SSH server..."
# Use `exec` to replace the shell process with the sshd process.
# This ensures it runs as the main process (PID 1) in the container.
# The -D flag keeps it in the foreground.
exec /usr/sbin/sshd -D
