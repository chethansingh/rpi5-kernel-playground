#!/bin/bash
set -e

KERNEL_IMAGE=${1:-"arch/arm64/boot/Image"}
ROOTFS=${2:-"rootfs.img"}

# Check if kernel exists
if [ ! -f "$KERNEL_IMAGE" ]; then
  echo "❌ Kernel image not found: $KERNEL_IMAGE"
  echo "Build your kernel first with:"
  echo "  make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig"
  echo "  make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)"
  exit 1
fi

# Create a simple rootfs if not present
if [ ! -f "$ROOTFS" ]; then
  echo "📦 Creating a minimal rootfs..."
  dd if=/dev/zero of=$ROOTFS bs=1M count=64
  mkfs.ext4 -F $ROOTFS
  mkdir -p mnt
  sudo mount -o loop $ROOTFS mnt
  sudo debootstrap --arch=arm64 jammy mnt http://ports.ubuntu.com/
  sudo umount mnt
fi

echo "🚀 Booting kernel in QEMU..."

qemu-system-aarch64 \
  -M virt \
  -cpu cortex-a76 \
  -m 2G \
  -smp 4 \
  -kernel "$KERNEL_IMAGE" \
  -append "root=/dev/vda rw console=ttyAMA0" \
  -drive if=none,file=$ROOTFS,format=raw,id=hd0 \
  -device virtio-blk-device,drive=hd0 \
  -netdev user,id=net0 -device virtio-net-device,netdev=net0 \
  -nographic
