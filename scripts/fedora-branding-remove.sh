#!/usr/bin/env bash

set -euo pipefail

rm -rf /usr/share/plasma/look-and-feel/org.fedoraproject.fedora.desktop
rm -rf /usr/share/wallpapers/Fedora
rm -rf /usr/share/wallpapers/F4*
rm -rf /usr/share/backgrounds/f4*
rm -rf /usr/share/sddm/themes/01-breeze-fedora

sed -i \
    's,org.fedoraproject.fedora.desktop,org.kde.breezetwilight.desktop,g' \
    /usr/share/kde-settings/kde-profile/default/xdg/kdeglobals

sed -i \
    's,#Current=01-breeze-fedora,Current=breeze,g' \
    /etc/sddm.conf
