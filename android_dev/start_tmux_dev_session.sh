#!/bin/bash
# This script checks for a tmux session named "dev-session".
# If the session exists, it attaches to it.
# If it does not exist, it creates a new session with that name.

tmux attach-session -t dev-session 2>/dev/null || tmux new-session -s dev-session
