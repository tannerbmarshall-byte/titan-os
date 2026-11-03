#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
CONFIG="$ROOT/build/live-build/auto/config"
PACKAGE_LIST="$ROOT/build/live-build/config/package-lists/titan.list.chroot"
HOOK="$ROOT/build/live-build/config/hooks/normal/0100-titan-services.chroot"
SERVICE_LINK="$ROOT/build/live-build/config/includes.chroot/etc/systemd/system/multi-user.target.wants/titan-zram.service"

sh -n "$CONFIG"
sh -n "$ROOT/build/live-build/auto/build"
sh -n "$HOOK"
grep -q -- '--distribution trixie' "$CONFIG"
grep -q -- '--architectures amd64' "$CONFIG"
grep -q -- '--binary-image iso' "$CONFIG"
grep -q -- '--bootloaders "grub-pc,grub-efi"' "$CONFIG"
grep -q -- '--uefi-secure-boot disable' "$CONFIG"
grep -q -- '--firmware-binary true' "$CONFIG"
grep -q 'titan-os-alpha-1.iso.sha256' "$ROOT/build/live-build/auto/build"
grep -q '^lxqt-core$' "$PACKAGE_LIST"
grep -q '^network-manager$' "$PACKAGE_LIST"
grep -q '^nm-tray$' "$PACKAGE_LIST"
grep -q '^pipewire$' "$PACKAGE_LIST"
grep -q '^pavucontrol-qt$' "$PACKAGE_LIST"
grep -q '^sddm$' "$PACKAGE_LIST"
grep -q '^cups$' "$PACKAGE_LIST"
grep -q '^unattended-upgrades$' "$PACKAGE_LIST"
grep -q '^ufw$' "$PACKAGE_LIST"
grep -q 'power-profiles-daemon.service' "$HOOK"
sh -n "$ROOT/build/live-build/config/hooks/normal/0200-titan-firewall.chroot"
[ -L "$SERVICE_LINK" ]

echo "live-build configuration checks passed"
