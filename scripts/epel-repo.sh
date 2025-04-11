#!/usr/bin/env bash

set -euo pipefail

dnf install -y \
    epel-release

crb enable
