#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
failures=0

require_file() {
    path=$1
    if [ -f "$ROOT/$path" ]; then
        printf 'PASS file     %s\n' "$path"
    else
        printf 'FAIL file     %s\n' "$path"
        failures=$((failures + 1))
    fi
}

require_text() {
    path=$1
    text=$2
    if grep -Fq -- "$text" "$ROOT/$path"; then
        printf 'PASS content  %s: %s\n' "$path" "$text"
    else
        printf 'FAIL content  %s: %s\n' "$path" "$text"
        failures=$((failures + 1))
    fi
}

for file in \
    README.md BUILDING.md HARDWARE.md TESTING.md ROADMAP.md \
    CONTRIBUTING.md LICENSE ARCHITECTURE.md DECISIONS.md \
    docs/HARDWARE-MATRIX.md \
    Makefile \
    scripts/check-package-list-debian.sh \
    scripts/validate-iso.sh \
    build/live-build/auto/config \
    build/live-build/config/package-lists/titan.list.chroot \
    build/live-build/config/includes.chroot/usr/local/bin/titan-first-run \
    build/live-build/config/includes.chroot/usr/local/bin/titan-hardware-info \
    build/live-build/config/includes.chroot/usr/local/bin/titan-suspend-diagnostics \
    build/live-build/config/includes.chroot/usr/local/bin/titan-performance-report \
    build/live-build/config/includes.chroot/usr/local/bin/titan-control-center \
    build/live-build/config/includes.chroot/usr/local/bin/titan-app-store \
    build/live-build/config/includes.chroot/usr/local/bin/titan-update-center \
    build/live-build/config/includes.chroot/usr/local/bin/titan-hardware-center \
    build/live-build/config/includes.chroot/usr/local/bin/titan-diagnostics-center \
    build/live-build/config/includes.chroot/usr/local/bin/titan-power-center \
    build/live-build/config/includes.chroot/usr/local/libexec/titan-zram-setup \
    build/live-build/config/includes.chroot/etc/systemd/system/titan-zram.service \
    build/live-build/config/includes.chroot/usr/share/backgrounds/titan-os.svg \
    tests/shell/test-zram-files.sh \
    tests/shell/test-user-tools.sh \
    tests/shell/test-live-build-config.sh \
    tests/shell/test-desktop-config.sh; do
    require_file "$file"
done

require_text build/live-build/auto/config '--distribution trixie'
require_text build/live-build/auto/config '--architectures amd64'
require_text build/live-build/auto/config '--binary-image iso'
require_text build/live-build/auto/config '--bootloaders "grub-pc,grub-efi"'
require_text build/live-build/config/package-lists/titan.list.chroot 'lxqt-core'
require_text build/live-build/config/package-lists/titan.list.chroot 'network-manager'
require_text build/live-build/config/package-lists/titan.list.chroot 'nm-tray'
require_text build/live-build/config/package-lists/titan.list.chroot 'pipewire'
require_text build/live-build/config/package-lists/titan.list.chroot 'pavucontrol-qt'
require_text build/live-build/config/package-lists/titan.list.chroot 'bluez'
require_text build/live-build/config/package-lists/titan.list.chroot 'cups'
require_text build/live-build/config/package-lists/titan.list.chroot 'ufw'
require_text build/live-build/config/package-lists/titan.list.chroot 'firefox-esr'
require_text build/live-build/config/includes.chroot/usr/local/bin/titan-hardware-info 'does not confirm hardware support'
require_text build/live-build/config/includes.chroot/usr/local/bin/titan-suspend-diagnostics 'does not claim suspend/resume support'
require_text build/live-build/config/includes.chroot/usr/local/bin/titan-performance-report 'measurements are observations'
require_text build/live-build/config/includes.chroot/usr/local/libexec/titan-zram-setup 'ZRAM_FRACTION'

if [ "$failures" -ne 0 ]; then
    echo "$failures MVP audit check(s) failed" >&2
    exit 1
fi

echo "Titan OS MVP source audit passed"
