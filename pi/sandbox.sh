#!/bin/bash

# Dynamically determine user and home directory
CURRENT_USER=$(id -u -n)
USER_HOME="/home/$CURRENT_USER"

# Dynamically find the NVM directory (defaults to ~/.nvm if not set)
NVM_DIR_PATH="${NVM_DIR:-$USER_HOME/.nvm}"

# Locate the current node binary path to make PATH agnostic
NODE_BIN_PATH=$(dirname "$(which node)")

# Get the absolute path of the current directory on the host
HOST_PWD=$(pwd)

bwrap \
  --ro-bind /usr /usr \
  --ro-bind /lib /lib \
  --ro-bind /lib64 /lib64 \
  --ro-bind /bin /bin \
  --ro-bind /sbin /sbin \
  --ro-bind /etc/alternatives /etc/alternatives \
  --ro-bind /etc/resolv.conf /etc/resolv.conf \
  --ro-bind /etc/ssl /etc/ssl \
  --ro-bind-try /etc/ca-certificates /etc/ca-certificates \
  --dir /tmp \
  --proc /proc \
  --dev /dev \
  --tmpfs /home \
  --tmpfs /dev/shm \
  --dir "$USER_HOME" \
  --bind "$HOST_PWD" "$HOST_PWD" \
  --chdir "$HOST_PWD" \
  --ro-bind-try "$USER_HOME/.local" "$USER_HOME/.local" \
  --bind-try "$USER_HOME/.cache/" "$USER_HOME/.cache/" \
  --bind-try "$USER_HOME/.local/share/uv" "$USER_HOME/.local/share/uv" \
  --ro-bind-try "$NVM_DIR_PATH" "$NVM_DIR_PATH" \
  --bind-try "$USER_HOME/.pi" "$USER_HOME/.pi" \
  --unshare-all \
  --share-net \
  --setenv PATH "$NODE_BIN_PATH:$USER_HOME/.local/bin:/usr/bin:/bin:" \
  --setenv HOME "$USER_HOME" \
  --setenv USER "$CURRENT_USER" \
  --setenv UV_LINK_MODE "copy" \
  --setenv ACADEMICCLOUD_API_KEY "$ACADEMICCLOUD_API_KEY" \
  "$@"
