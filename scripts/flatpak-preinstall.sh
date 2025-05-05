#!/usr/bin/env bash

set -euo pipefail

mkdir -p \
    /etc/flatpak/preinstall.d

cat << EOF > /etc/flatpak/preinstall.d/firefox.preinstall
[Flatpak Preinstall org.mozilla.firefox]
Branch=stable
EOF

flatpak preinstall -y
