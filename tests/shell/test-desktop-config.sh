#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
OPENBOX="$ROOT/build/live-build/config/includes.chroot/etc/skel/.config/openbox/rc.xml"
AUTOSTART="$ROOT/build/live-build/config/includes.chroot/etc/skel/.config/openbox/autostart"
SYSTEM_AUTOSTART="$ROOT/build/live-build/config/includes.chroot/etc/xdg/openbox/autostart"
DESKTOP_SHELL="$ROOT/build/live-build/config/includes.chroot/etc/xdg/autostart/titan-desktop-shell.desktop"
XSESSION_SHELL="$ROOT/build/live-build/config/includes.chroot/etc/X11/Xsession.d/99titan-desktop-shell"
WALLPAPER="$ROOT/build/live-build/config/includes.chroot/usr/share/backgrounds/titan-os.svg"
DEFAULTS="$ROOT/build/live-build/config/includes.chroot/usr/local/share/titan-os/apply-defaults"
PACKAGE_LIST="$ROOT/build/live-build/config/package-lists/titan.list.chroot"

command -v xmllint >/dev/null 2>&1 && xmllint --noout "$OPENBOX" || true
sh -n "$DEFAULTS"
test -x "$AUTOSTART"
test -x "$SYSTEM_AUTOSTART"
test -x "$XSESSION_SHELL"
grep -q 'XF86AudioRaiseVolume' "$OPENBOX"
grep -q 'XF86MonBrightnessUp' "$OPENBOX"
grep -q 'lxqt-panel' "$AUTOSTART"
grep -q 'pcmanfm-qt --desktop' "$AUTOSTART"
grep -q 'lxqt-panel' "$SYSTEM_AUTOSTART"
grep -q 'pcmanfm-qt --desktop' "$SYSTEM_AUTOSTART"
grep -q '^Exec=sh -c' "$DESKTOP_SHELL"
grep -q 'lxqt-panel' "$XSESSION_SHELL"
grep -q 'pcmanfm-qt --desktop' "$XSESSION_SHELL"
grep -q 'TITAN OS' "$WALLPAPER"
grep -q '^brightnessctl$' "$PACKAGE_LIST"
grep -q '^power-profiles-daemon$' "$PACKAGE_LIST"

echo "desktop configuration checks passed"
