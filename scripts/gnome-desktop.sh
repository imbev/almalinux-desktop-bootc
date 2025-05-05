#!/usr/bin/env bash

set -euo pipefail

dnf install -y \
    -x firefox \
    @"Workstation"

systemctl enable gdm
