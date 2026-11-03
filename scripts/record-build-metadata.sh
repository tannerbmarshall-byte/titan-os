#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
OUTPUT=${1:-"$ROOT/build/live-build/build-metadata.txt"}

mkdir -p "$(dirname -- "$OUTPUT")"
{
    printf 'Titan OS build metadata\n'
    printf 'Recorded UTC: '
    date -u '+%Y-%m-%dT%H:%M:%SZ'
    printf 'Project release: '
    sed -n 's/^VERSION=//p' "$ROOT/build/live-build/config/includes.chroot/etc/titan-os/release"
    printf 'Project codename: '
    sed -n 's/^CODENAME=//p' "$ROOT/build/live-build/config/includes.chroot/etc/titan-os/release"
    printf 'Project architecture: '
    sed -n 's/^ARCHITECTURE=//p' "$ROOT/build/live-build/config/includes.chroot/etc/titan-os/release"
    printf 'Kernel builder: '
    if command -v lb >/dev/null 2>&1; then lb --version 2>&1 | head -n 1; else printf 'unavailable\n'; fi
    printf 'Package list SHA256: '
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$ROOT/build/live-build/config/package-lists/titan.list.chroot" | awk '{print $1}'
    else
        shasum -a 256 "$ROOT/build/live-build/config/package-lists/titan.list.chroot" | awk '{print $1}'
    fi
} > "$OUTPUT"

echo "build metadata written to $OUTPUT"
