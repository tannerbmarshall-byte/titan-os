#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
LIST="$ROOT/build/live-build/config/package-lists/titan.list.chroot"

if ! command -v apt-cache >/dev/null 2>&1; then
    echo "apt-cache is required; run this script inside Debian" >&2
    exit 2
fi

failures=0
while IFS= read -r package || [ -n "$package" ]; do
    case "$package" in
        ''|'#'*) continue ;;
    esac
    if apt-cache show "$package" >/dev/null 2>&1; then
        printf 'OK      %s\n' "$package"
    else
        printf 'MISSING %s\n' "$package"
        failures=$((failures + 1))
    fi
done < "$LIST"

if [ "$failures" -ne 0 ]; then
    echo "$failures package(s) are unavailable in the configured Debian repositories" >&2
    exit 1
fi

echo "Debian package-list check passed"
