#!/bin/sh
set -eu

usage() {
    echo "Usage: validate-iso.sh ISO_PATH [CHECKSUM_PATH]" >&2
    exit 2
}

[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage
iso=$1
checksum=${2:-}

[ -f "$iso" ] || { echo "ISO not found: $iso" >&2; exit 1; }

if command -v xorriso >/dev/null 2>&1; then
    xorriso -indev "$iso" -toc >/dev/null
elif command -v isoinfo >/dev/null 2>&1; then
    isoinfo -d -i "$iso" >/dev/null
else
    echo "Neither xorriso nor isoinfo is available" >&2
    exit 1
fi

if command -v sha256sum >/dev/null 2>&1; then
    actual=$(sha256sum "$iso" | awk '{print $1}')
else
    actual=$(shasum -a 256 "$iso" | awk '{print $1}')
fi

printf 'ISO structure: validated\n'
printf 'ISO SHA-256: %s\n' "$actual"
printf 'Boot status: not established by this check\n'

if [ -n "$checksum" ]; then
    [ -f "$checksum" ] || { echo "Checksum file not found: $checksum" >&2; exit 1; }
    expected=$(awk 'NF { print $1; exit }' "$checksum")
    [ "$actual" = "$expected" ] || { echo "checksum mismatch" >&2; exit 1; }
    echo "Checksum: validated"
fi
