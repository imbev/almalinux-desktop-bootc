#!/usr/bin/env bash

set -euo pipefail

# Disable the automatic reboot on the update service for bootc
mkdir -p /etc/systemd/system/bootc-fetch-apply-updates.service.d
cat << EOF > /etc/systemd/system/bootc-fetch-apply-updates.service.d/10-no-apply.conf
[Service]
ExecStart=
ExecStart=/usr/bin/bootc update --quiet
EOF
