#!/usr/bin/env bash

set -euo pipefail

bootc container lint --fatal-warnings || true
