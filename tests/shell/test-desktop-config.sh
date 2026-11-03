#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
OPENBOX="$ROOT/build/live-build/config/includes.chroot/etc/skel/.config/openbox/rc.xml"
AUTOSTART="$ROOT/build/live-build/config/includes.chroot/etc/skel/.config/openbox/autostart"
WALLPAPER="$ROOT/build/live-build/config/includes.chroot/usr/share/backgrounds/titan-os.svg"
DEFAULTS="$ROOT/build/live-build/config/includes.chroot/usr/local/share/titan-os/apply-defaults"
PACKAGE_LIST="$ROOT/build/live-build/config/package-lists/titan.list.chroot"

command -v xmllint >/dev/null 2>&1 && xmllint --noout "$OPENBOX" || true
sh -n "$DEFAULTS"
test -x "$AUTOSTART"
grep -q 'XF86AudioRaiseVolume' "$OPENBOX"
grep -q 'XF86MonBrightnessUp' "$OPENBOX"
grep -q 'lxqt-panel' "$AUTOSTART"
grep -q 'pcmanfm-qt --desktop' "$AUTOSTART"
grep -q 'TITAN OS' "$WALLPAPER"
grep -q '^brightnessctl$' "$PACKAGE_LIST"
grep -q '^power-profiles-daemon$' "$PACKAGE_LIST"

echo "desktop configuration checks passed"
