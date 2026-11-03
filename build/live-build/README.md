# Titan OS live-build configuration

This directory contains the first x86-64 live-image skeleton for Titan OS Alpha 1.

## Current policy

- Debian 13.7 “trixie”
- amd64 only
- ISO live image
- systemd
- `main` and `contrib` archive areas
- no `non-free-firmware` by default
- curated LXQt package list
- SHA-256 checksums

The configuration has not yet been executed. A Linux build environment with Debian `live-build` is required before the first ISO build.

## Planned commands

From this directory, after the build environment is prepared:

```sh
./auto/config
./auto/build
```

Clean generated build state only when intentionally restarting:

```sh
./auto/clean
```

The package list is intentionally conservative. Browser choice, branding assets, first-run setup, diagnostics, zram configuration, printer support, and update/recovery behavior will be added in separate steps after the base image configuration is validated.
