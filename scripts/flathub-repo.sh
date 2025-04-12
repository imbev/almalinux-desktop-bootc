#!/usr/bin/env bash

set -euo pipefail

mkdir -p \
    /etc/flatpak/remotes.d

curl \
    --retry 3 \
    -o /etc/flatpak/remotes.d/flathub.flatpakrepo \
    https://dl.flathub.org/repo/flathub.flatpakrepo