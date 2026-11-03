# Titan OS Hardware Plan

## Priority target

The first physical test target is the 2010 13-inch MacBook Pro with a 2.66 GHz Intel Core 2 Duo processor.

Apple identifies the likely target as `MacBookPro7,1`, with NVIDIA GeForce 320M graphics, a 1280×800 display, Apple multi-touch trackpad, iSight camera, 802.11n AirPort, Bluetooth 2.1, Gigabit Ethernet, and up to 8 GB RAM. These specifications are planning context only; Linux support still requires testing on the exact unit.

## Hardware areas to test

- EFI boot
- Legacy boot where practical
- Intel integrated graphics
- Internal display and external display behavior
- Apple keyboard and special keys
- Trackpad tapping, scrolling, and palm rejection
- Wi-Fi chipset detection and free-firmware availability
- Bluetooth
- Webcam
- Speakers, microphone, and headphone jack
- Volume and brightness keys
- Battery reporting
- Power management and thermal behavior
- Suspend and resume

The `titan-suspend-diagnostics` command records available sleep states, power-manager capabilities, kernel warnings from the current and previous boot, and an explicit untested status. It should be run before and after each physical suspend/resume test.

## Firmware policy

Titan OS Alpha 1 will use free firmware by default. If a device requires proprietary firmware, the system will explain the limitation and provide documented, user-controlled installation guidance where legally and technically appropriate.

## Compatibility evidence

The current status matrix is maintained in [docs/HARDWARE-MATRIX.md](docs/HARDWARE-MATRIX.md).

Each feature record should include:

- Exact machine model and hardware identifiers
- Titan OS build or commit
- Kernel version
- Required packages or firmware
- Test procedure
- Result and limitations
- Status: confirmed, partial, untested, unsupported, or unknown

No hardware feature should be called confirmed based only on the model year or a similar computer.
