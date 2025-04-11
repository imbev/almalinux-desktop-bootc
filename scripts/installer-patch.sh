#!/usr/bin/env bash

set -euo pipefail

echo "ostreecontainer --url quay.io/almalinuxorg/almalinux-bootc:${MAJOR}-${VARIANT}-bootc" \
    >> /almalinux-desktop-bootc.ks

rm -f /pwd/AlmaLinux-10-${VARIANT}-bootc-latest-beta-${ARCH}-boot.iso

dnf install -y \
    lorax

mkksiso \
    --ks /almalinux-desktop-bootc.ks \
    /pwd/AlmaLinux-10-latest-beta-${ARCH}-boot.iso \
    /pwd/AlmaLinux-10-${VARIANT}-bootc-latest-beta-${ARCH}-boot.iso
