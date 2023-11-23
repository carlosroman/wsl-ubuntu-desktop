#!/usr/bin/env sh
set -e

apt-get update
apt install --no-install-recommends \
    autoconf \
    gcc \
    libffi-dev \
    make \
    python3-debian \
    python3-venv
