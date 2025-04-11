#!/usr/bin/env bash

set -euo pipefail

dnf install -y \
    @"Workstation"

systemctl enable gdm
