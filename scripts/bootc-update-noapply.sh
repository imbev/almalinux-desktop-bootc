#!/usr/bin/env bash

set -euo pipefail

sed -i \
    's,ExecStart=/usr/bin/bootc update --apply --quiet,ExecStart=/usr/bin/bootc update --quiet,g' \
    /usr/lib/systemd/system/bootc-fetch-apply-updates.service
