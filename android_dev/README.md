# Android Dev Docker Image

This Docker image is designed for local personal Android development and includes a variety of tools to streamline your workflow.

## Included Tools

*   **pnpm**: A fast and disk-space-efficient package manager for Node.js.
*   **Node.js**: A JavaScript runtime built on Chrome's V8 JavaScript engine.
*   **@google/gemini-cli**: A command-line interface for Google's Gemini models.
*   **zsh**: A powerful and feature-rich shell.
*   **oh-my-zsh**: A framework for managing your zsh configuration.

## Building the Image

To build the image, run the following command from the root of the repository:

```bash
docker build -t android_dev -f android_dev/Dockerfile .
```

## Running the Image

To run the image, use the following command:

```bash
docker run -it -v ~/.ssh:/root/.ssh android_dev
```

This will start an interactive shell in the container. The `-v ~/.ssh:/root/.ssh` flag mounts your host's SSH keys into the container, which is necessary for cloning private repositories.

### Cloning a Repository

The `entrypoint.sh` script will automatically clone a git repository when the container starts. You can customize the repository, branch, and provider using the following environment variables:

*   `git_repo`: The repository to clone. Defaults to `AnySoftKeyboard/AnySoftKeyboard`.
*   `git_brach`: The branch to clone. Defaults to `main`.
*   `git_provider`: The git provider. Defaults to `github.com`.

For example, to clone a different repository, you can run the following command:

```bash
docker run -it -v ~/.ssh:/root/.ssh -e git_repo="my-repo/my-project" -e git_brach="develop" android_dev
```
