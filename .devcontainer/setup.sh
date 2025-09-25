#!/bin/bash
set -e

echo "🔧 Installing kernel build dependencies..."

# Update package lists
sudo apt-get update

# Install required tools for Linux kernel build
sudo apt-get install -y \
  build-essential \
  gcc-aarch64-linux-gnu \
  g++-aarch64-linux-gnu \
  qemu-system-arm \
  qemu-system-aarch64 \
  bc \
  flex \
  bison \
  libssl-dev \
  libncurses-dev \
  dwarves \
  git \
  wget \
  curl \
  ccache \
  python3 \
  python3-pip

echo "✅ Kernel build environment ready!"
