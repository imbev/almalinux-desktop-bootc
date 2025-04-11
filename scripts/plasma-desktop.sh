#!/usr/bin/env bash

set -euo pipefail

dnf install -y \
    @"KDE Plasma Workspaces"

systemctl enable sddm
