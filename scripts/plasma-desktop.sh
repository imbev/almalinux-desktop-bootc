#!/usr/bin/env bash

set -euo pipefail

dnf install -y \
    -x plasma-discover-packagekit \
    @"KDE Plasma Workspaces" \
    falkon

sed -i \
    's,Image=Next,Image=Alma-default,g' \
    /usr/share/plasma/look-and-feel/org.kde.breeze.desktop/contents/defaults

sed -i \
    's,Image=Next,Image=Alma-default,g' \
    /usr/share/plasma/look-and-feel/org.kde.breezedark.desktop/contents/defaults

sed -i \
    's,Image=Next,Image=Alma-default,g' \
    /usr/share/plasma/look-and-feel/org.kde.breezetwilight.desktop/contents/defaults

sed -i \
    's,start-here-kde-symbolic,fedora-logo-icon,g' \
    /usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml

sed -i \
    's,background=/usr/share/wallpapers/Next/contents/images/5120x2880.png,background=/usr/share/wallpapers/Alma-default/contents/images/3840x2160.png,g' \
    /usr/share/sddm/themes/breeze/theme.conf

systemctl enable sddm
