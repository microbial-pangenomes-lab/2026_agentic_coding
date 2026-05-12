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
  --unshare-user \
  --uid 0 \
  --gid 0 \
  --unshare-ipc \
  --unshare-pid \
  --unshare-uts \
  --unshare-cgroup \
  --unshare-cgroup-try \
  --share-net \
  --ro-bind /usr /usr \
  --ro-bind-try /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu \
  --ro-bind-try /usr/lib64 /usr/lib64 \
  --ro-bind-try /usr/local/cuda /usr/local/cuda \
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
  --dev-bind /dev/nvidia0 /dev/nvidia0 \
  --dev-bind /dev/nvidia1 /dev/nvidia1 \
  --dev-bind-try /dev/nvidia2 /dev/nvidia2 \
  --dev-bind-try /dev/nvidia3 /dev/nvidia3 \
  --dev-bind-try /dev/nvidia4 /dev/nvidia4 \
  --dev-bind-try /dev/nvidia5 /dev/nvidia5 \
  --dev-bind-try /dev/nvidia6 /dev/nvidia6 \
  --dev-bind-try /dev/nvidia7 /dev/nvidia7 \
  --dev-bind /dev/nvidiactl /dev/nvidiactl \
  --dev-bind /dev/nvidia-uvm /dev/nvidia-uvm \
  --dev-bind /dev/nvidia-modeset /dev/nvidia-modeset \
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
  --setenv PATH "$NODE_BIN_PATH:$USER_HOME/.local/bin:/usr/bin:/bin:" \
  --setenv HOME "$USER_HOME" \
  --setenv USER "$CURRENT_USER" \
  --setenv UV_LINK_MODE "copy" \
  --setenv ACADEMICCLOUD_API_KEY "$ACADEMICCLOUD_API_KEY" \
  "$@"
