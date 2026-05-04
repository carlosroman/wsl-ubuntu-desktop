#!/usr/bin/env sh
set -e

apt-get update
apt install --no-install-recommends \
    autoconf \
    automake \
    gcc \
    git \
    libffi-dev \
    make 
