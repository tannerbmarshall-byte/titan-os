#!/bin/sh
set -eu

strict=no
if [ "${1:-}" = "--strict" ]; then
    strict=yes
elif [ "$#" -gt 0 ]; then
    echo "Usage: doctor.sh [--strict]" >&2
    exit 2
fi

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
missing=0

check_command() {
    name=$1
    if command -v "$name" >/dev/null 2>&1; then
        printf 'OK       %-20s %s\n' "$name" "$(command -v "$name")"
    else
        printf 'MISSING  %-20s\n' "$name"
        missing=$((missing + 1))
    fi
}

echo "Titan OS build doctor"
echo "Project: $ROOT"
echo

for command_name in lb debootstrap xorriso make; do
    check_command "$command_name"
done

if command -v sha256sum >/dev/null 2>&1 || command -v shasum >/dev/null 2>&1; then
    printf 'OK       %-20s %s\n' "sha256 tool" "available"
else
    printf 'MISSING  %-20s\n' "sha256 tool"
    missing=$((missing + 1))
fi

echo
if [ -f /etc/debian_version ]; then
    printf 'OS:      Debian %s\n' "$(cat /etc/debian_version)"
else
    printf 'OS:      non-Debian host\n'
    missing=$((missing + 1))
fi

if [ "$missing" -eq 0 ]; then
    echo "Build prerequisites appear available."
    exit 0
fi

echo "$missing prerequisite check(s) need attention."
if [ "$strict" = yes ]; then
    exit 1
fi
echo "Non-strict mode: continuing with diagnostics only."
