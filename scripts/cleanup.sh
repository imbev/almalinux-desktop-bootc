#!/usr/bin/env bash

set -euo pipefail

rm -rf /scripts

dnf clean all

bootc container lint --fatal-warnings || true
