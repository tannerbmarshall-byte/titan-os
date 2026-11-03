#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
LIST="$ROOT/build/live-build/config/package-lists/titan.list.chroot"

awk '
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    { if ($1 != $0) { print "invalid package-list line: " $0 > "/dev/stderr"; bad=1 }
      if (seen[$0]++) { print "duplicate package: " $0 > "/dev/stderr"; bad=1 } }
    END { exit bad }
' "$LIST"

echo "package list checks passed"
