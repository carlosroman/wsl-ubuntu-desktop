#!/usr/bin/env sh
set -e

apt-get update
apt install gcc autoconf make python3-venv libffi-dev --no-install-recommends
