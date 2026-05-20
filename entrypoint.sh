#!/bin/bash
# Docker Desktop mounts the SSH agent socket with root-only permissions
if [ -S "$SSH_AUTH_SOCK" ]; then
  sudo chmod 666 "$SSH_AUTH_SOCK"
fi
exec "$@"
