# Building Titan OS

## Current status

The live-build configuration is implemented but has not yet produced an ISO. A Debian 13/trixie amd64 build environment is required. The current macOS host does not have `live-build`, `debootstrap`, `xorriso`, or a Linux VM/container runtime installed.

An optional Debian builder definition is available in [build/container](build/container). It can be used with Docker or Podman on a host where one of those runtimes is already approved and configured.

For a remote build, use the workflow described in [CI.md](CI.md).

The CI workflow also checks every package name inside a clean Debian trixie container before running live-build.

## Required environment

Check the current environment before building:

```sh
make doctor
```

Use `scripts/doctor.sh --strict` when a missing prerequisite should fail the check.

Use a clean Debian 13/trixie amd64 environment with:

```text
live-build
debootstrap
xorriso
isolinux
syslinux-common
grub-pc-bin
grub-efi-amd64-bin
dosfstools
```

The build user must be able to install packages and write the project directory. Do not run the build as root unless the Debian live-build documentation requires it for the selected environment.

## Build commands

From the Titan OS project root:

```sh
make test
make configure
make build
```

To remove generated live-build state:

```sh
make clean
```

The result should include an ISO and SHA-256 checksum. Preserve the build log, package manifest, checksum, Debian suite, kernel version, and live-build version with every test artifact.

Record local build metadata with:

```sh
make metadata
```

Validate a release artifact with:

```sh
make validate-release ISO=/path/to/titan-os.iso CHECKSUM=/path/to/titan-os.iso.sha256
```

Inspect the ISO structure without claiming it boots:

```sh
make validate-iso ISO=/path/to/titan-os.iso CHECKSUM=/path/to/titan-os.iso.sha256
```

## Firmware policy

The configuration uses `main` and `contrib` and does not enable `non-free-firmware` by default. Missing firmware must be reported rather than silently treated as supported.

## Build safety

- Build in a disposable or dedicated Debian environment.
- Do not point live-build at a host installation disk.
- Do not run generated installer code; Alpha 1 is live-only.
- Validate the ISO in a test environment before physical hardware testing.
