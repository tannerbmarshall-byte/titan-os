#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
SETUP="$ROOT/build/live-build/config/includes.chroot/usr/local/libexec/titan-zram-setup"
TEARDOWN="$ROOT/build/live-build/config/includes.chroot/usr/local/libexec/titan-zram-teardown"
SERVICE="$ROOT/build/live-build/config/includes.chroot/etc/systemd/system/titan-zram.service"
CONFIG="$ROOT/build/live-build/config/includes.chroot/etc/default/titan-zram"

sh -n "$SETUP"
sh -n "$TEARDOWN"

grep -q '^ZRAM_FRACTION=50$' "$CONFIG"
grep -q '^ExecStart=/usr/local/libexec/titan-zram-setup$' "$SERVICE"
grep -q '^ExecStop=/usr/local/libexec/titan-zram-teardown$' "$SERVICE"
grep -q -- '--priority' "$SETUP"
grep -q -- '--reset' "$TEARDOWN"

echo "zram configuration checks passed"
