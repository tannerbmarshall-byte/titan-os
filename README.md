# Titan OS

Titan OS is a lightweight Debian-based Linux distribution designed to make older x86-64 computers useful again. Its first hardware target is the 2010 13-inch MacBook Pro with a 2.66 GHz Intel Core 2 Duo processor.

## Project status

**Planning complete. Implementation has not started.**

The first planned release is **Titan OS Alpha 1**: a live ISO focused on x86-64 hardware. It will use LXQt on Xorg, standard Debian components, automatic zram, Firefox ESR, FeatherPad, a small default application set, and transparent hardware-status reporting.

ARM and 32-bit x86 are planned as separate future build targets, not as part of the first MVP image.

## Goals

- Low idle memory usage without imposing an artificial RAM limit
- Usable operation on systems with approximately 1 GB of RAM
- Good responsiveness on older Core 2 Duo hardware
- Reproducible ISO builds
- Modular, replaceable desktop components
- Evidence-based hardware compatibility reporting
- No unnecessary telemetry, background services, animations, or bundled web services

## Current decisions

- Base: Debian 13.7 “trixie” (codename pinned in builds)
- Desktop: LXQt
- Display stack: Xorg
- Init and services: systemd
- Networking: NetworkManager
- Audio: PipeWire
- Memory pressure: zram plus disk swap when available
- Firmware policy: free firmware by default; optional proprietary firmware is documented and user-controlled
- First release: live ISO only, without an installer
- Updates: automatic and user-controllable, with recovery records
- Telemetry: opt-in, local/export-only, hardware and performance data only

Phase 1 research is recorded in [docs/research/phase-1.md](docs/research/phase-1.md). The current package strategy is a curated LXQt installation based on `lxqt-core`, not the full `lxqt` desktop metapackage, so memory and service costs can be measured deliberately. The live-build skeleton, zram configuration, first-run setup, and offline hardware report are now implemented but not yet built into an ISO.

See [ARCHITECTURE.md](ARCHITECTURE.md) and [DECISIONS.md](DECISIONS.md) for the full plan.

## Important limitation

Hardware support is not confirmed until tested on real hardware. Virtual-machine tests and documentation research are not substitutes for MacBook testing.
