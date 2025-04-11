#!/usr/bin/env bash

set -euo pipefail

dnf install -y \
    @"KDE Plasma Workspaces" \
    falkon

systemctl enable sddm
