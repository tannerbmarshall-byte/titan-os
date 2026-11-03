# Titan OS Decisions

This document records decisions made during planning. New decisions should be added rather than silently changing existing ones.

## Accepted decisions

| Area | Decision | Reason or consequence |
|---|---|---|
| Base | Debian 13.7 “trixie”, pinned by codename | Current Stable baseline with reproducible suite selection |
| Desktop | Curated LXQt based on `lxqt-core` | Better integration than a bare window manager while avoiding the full metapackage footprint |
| Display | Xorg first | Safer baseline for older graphics hardware |
| Build | Debian `live-build` | Reproducible, distribution-native ISO generation |
| Init | systemd | Debian’s maintained default service model |
| Network | NetworkManager | Broad desktop and Wi-Fi integration |
| Audio | PipeWire | Modern audio and Bluetooth integration |
| Memory | zram plus disk swap | Preserve responsiveness under memory pressure |
| Firmware | Free firmware by default | Avoid automatic proprietary firmware installation |
| Boot | EFI and legacy targets where practical | Support the MacBook’s possible boot modes |
| Installer | Deferred | Alpha 1 is a live ISO only |
| Login | Graphical login | Normal desktop startup experience |
| Themes | Light and dark | User choice without heavy visual effects |
| Updates | Automatic, user-controllable | Convenience with an opt-out and recovery record |
| Telemetry | Opt-in, local/export-only | Hardware and performance data without a remote service |
| Architecture | x86-64 MVP; ARM and 32-bit later | Keep the first image focused while preserving portability |
| Compatibility | Evidence required for “confirmed” | Prevent unsupported hardware claims |

## Research-backed constraints

- The first ISO must target amd64/x86-64. Debian 13 treats i386 as a co-architecture rather than a normal new-installation target, so 32-bit support needs a separate feasibility decision.
- The build must explicitly set the Debian suite, archive areas, firmware behavior, architecture, image type, init system, boot targets, and checksums.
- The exact MacBook Wi-Fi PCI identifier must be collected from real hardware before selecting a driver or claiming Wi-Fi support.
- The NVIDIA GeForce 320M, Apple trackpad, battery, camera, audio, and suspend/resume each require separate physical tests.

## Deferred decisions

- Browser memory behavior and compatibility still require measurement; the initial candidate is Firefox ESR.
- Exact firmware package selection
- Exact update recovery mechanism
- Installer technology for a later release
- Public telemetry export format
- ARM and 32-bit release schedule
- Final visual identity and logo assets
