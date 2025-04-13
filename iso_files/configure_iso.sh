#!/usr/bin/env bash

set -x

dnf install -y \
  anaconda \
  anaconda-install-env-deps \
  anaconda-live

systemctl --global disable podman-auto-update.timer
