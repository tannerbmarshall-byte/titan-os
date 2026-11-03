#!/bin/sh
set -eu

usage() {
    echo "Usage: validate-release.sh ISO_PATH CHECKSUM_PATH" >&2
    exit 2
}

[ "$#" -eq 2 ] || usage
iso=$1
checksum=$2

[ -f "$iso" ] || { echo "ISO not found: $iso" >&2; exit 1; }
[ -f "$checksum" ] || { echo "Checksum file not found: $checksum" >&2; exit 1; }

if command -v sha256sum >/dev/null 2>&1; then
    expected=$(awk 'NF { print $1; exit }' "$checksum")
    actual=$(sha256sum "$iso" | awk '{print $1}')
else
    expected=$(awk 'NF { print $1; exit }' "$checksum")
    actual=$(shasum -a 256 "$iso" | awk '{print $1}')
fi

[ "$expected" = "$actual" ] || {
    echo "checksum mismatch" >&2
    exit 1
}

echo "release artifact and checksum validated"
