#!/bin/sh
set -eu

if [ -z "$INPUT_SSH_USER" ]; then
    echo "Input INPUT_SSH_USER is required!"
    exit 1
fi

if [ -z "$INPUT_SSH_HOST" ]; then
    echo "Input INPUT_SSH_HOST is required!"
    exit 1
fi

if [ -z "$INPUT_SSH_PRIVATE_KEY" ]; then
    echo "Input INPUT_SSH_PRIVATE_KEY is required!"
    exit 1
fi

echo "Registering SSH keys..."

# Save private key to a file and register it with the agent.
mkdir -p "$HOME/.ssh"
printf '%s' "$INPUT_SSH_PRIVATE_KEY" > "$HOME/.ssh/docker"
chmod 600 "$HOME/.ssh/docker"
eval $(ssh-agent)
ssh-add "$HOME/.ssh/docker"

# Add public key to known hosts.
ssh-keyscan -t rsa $INPUT_SSH_HOST >> ~/.ssh/known_hosts

echo "Connecting to $INPUT_SSH_HOST..."
docker --log-level debug --host ssh://$INPUT_SSH_USER@$INPUT_SSH_HOST "$@" 2>&1