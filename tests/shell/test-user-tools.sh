#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
FIRST_RUN="$ROOT/build/live-build/config/includes.chroot/usr/local/bin/titan-first-run"
HARDWARE="$ROOT/build/live-build/config/includes.chroot/usr/local/bin/titan-hardware-info"
SUSPEND="$ROOT/build/live-build/config/includes.chroot/usr/local/bin/titan-suspend-diagnostics"
PERFORMANCE="$ROOT/build/live-build/config/includes.chroot/usr/local/bin/titan-performance-report"
AUTOSTART="$ROOT/build/live-build/config/includes.chroot/etc/xdg/autostart/titan-first-run.desktop"
BRANDED_DIR="$ROOT/build/live-build/config/includes.chroot/usr/local/bin"
CONTROL_DESKTOP="$ROOT/build/live-build/config/includes.chroot/usr/share/applications/titan-control-center.desktop"
CONTROL_ICON="$ROOT/build/live-build/config/includes.chroot/usr/share/icons/hicolor/scalable/apps/titan-control-center.svg"

sh -n "$FIRST_RUN"
sh -n "$HARDWARE"
sh -n "$SUSPEND"
sh -n "$PERFORMANCE"
grep -q '^Exec=/usr/local/bin/titan-first-run$' "$AUTOSTART"
grep -q 'does not confirm hardware support' "$HARDWARE"
grep -q 'Compatibility status:' "$HARDWARE"
grep -q 'does not claim suspend/resume support' "$SUSPEND"
grep -q 'measurements are observations' "$PERFORMANCE"
grep -q 'telemetry=' "$FIRST_RUN"
grep -q -- '--save' "$HARDWARE"
for branded in titan-control-center titan-app-store titan-update-center \
    titan-hardware-center titan-diagnostics-center titan-power-center; do
    test -x "$BRANDED_DIR/$branded"
    sh -n "$BRANDED_DIR/$branded"
done
grep -q '^Exec=/usr/local/bin/titan-control-center$' "$CONTROL_DESKTOP"
test -s "$CONTROL_ICON"

echo "first-run and hardware-report checks passed"
