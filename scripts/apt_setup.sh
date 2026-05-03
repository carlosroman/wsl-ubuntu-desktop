#!/usr/bin/env sh
set -e

apt-get update
apt install --no-install-recommends \
    autoconf \
    automake \
    gcc \
    libffi-dev \
    make 
