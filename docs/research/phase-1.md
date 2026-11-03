# Titan OS Phase 1 research

**Date:** 2026-11-03  
**Scope:** Debian Stable/live-build, LXQt packaging and service implications, firmware policy, 2010 13-inch MacBook Pro Linux considerations, and an x86-64 MVP package/service baseline.  
**Method:** Primary sources only: Debian documentation and package metadata, Linux kernel documentation, and Apple technical specifications. No ISO was built and no host settings were changed.

## Executive summary

Titan OS should target **Debian 13.7 “trixie”** as the current Stable release and use `live-build` with an explicit `trixie` configuration. Debian 13 was initially released on 2025-08-09; the current Stable point release is 13.7, released 2026-09-12. Debian’s release information lists full support through 2028-08-09 and LTS through 2030-06-30. The release information also says that i386 is supported only as an amd64 co-architecture, so the first Titan image should remain amd64/x86-64; a future 32-bit target will need a separate feasibility decision rather than being assumed to be a normal Debian 13 installation target. [Debian releases](https://www.debian.org/releases/index.en.html), [Debian 13 release information](https://www.debian.org/releases/trixie/), [Debian 13.7 announcement](https://www.debian.org/News/2026/20260912)

The selected LXQt direction is practical, but the full `lxqt` metapackage is not the same thing as a minimal desktop: its package metadata pulls in a broad set of components and recommends a display manager, terminal, power management, volume control, clipboard, process manager, and other desktop conveniences. For Titan’s memory target, the baseline should start from `lxqt-core` plus a deliberately selected set of packages, then add only features that pass measurement. [Debian LXQt wiki](https://wiki.debian.org/LXQt), [Debian `lxqt` package metadata](https://packages.debian.org/trixie/lxqt), [Debian `lxqt-session` metadata](https://packages.debian.org/trixie/lxqt-session)

The 2010 13-inch MacBook Pro is specifically the Apple `MacBookPro7,1` and has a Core 2 Duo CPU, NVIDIA GeForce 320M graphics, 1280×800 internal display, Apple multi-touch trackpad, iSight camera, 802.11n AirPort, Bluetooth 2.1, Gigabit Ethernet, and up to 8 GB RAM according to Apple. The exact Wi-Fi PCI ID and firmware requirement must still be collected from the actual unit. Apple’s specification does not establish Linux driver support. [Apple model identification](https://support.apple.com/en-ie/108052), [Apple technical specifications](https://support.apple.com/en-in/112604)

The largest policy/design conflict is firmware. Titan’s approved policy is free firmware only by default, but Debian’s current live-build defaults include firmware in both the live image and installer path, and Debian states that many useful firmware packages are in `non-free-firmware`. Therefore Titan must explicitly set its archive areas and firmware behavior, document the trade-off, and report missing firmware rather than silently claiming complete wireless support. [Debian Firmware wiki](https://wiki.debian.org/Firmware), [Debian Policy §2.2.2](https://www.debian.org/doc/debian-policy/policy.html#s-non-free-firmware), [`lb_config(1)`](https://manpages.debian.org/trixie/live-build/lb_config.1.en.html)

## 1. Current Debian Stable

### Findings

- Current Stable is Debian 13, codename **trixie**. The Debian release page identifies 13.0’s release date as 2025-08-09 and lists 13 as the current Stable release.
- Debian’s current official release information reports point release 13.7 on 2026-09-12.
- Debian 13’s supported architecture list includes amd64 and several ARM architectures. i386 is described as a co-architecture for running 32-bit software on amd64, not as a normal new-installation architecture for the first release. `armel` is also restricted to upgrades and not new installations.

### Titan decision

Use `trixie` explicitly in build configuration and documentation rather than the moving `stable` alias. The build can still use Debian’s Stable repositories, but pinning the codename makes a reproducible build easier to audit and prevents an unnoticed future Stable transition from changing the MVP base.

### Caveat

“Stable” does not mean every package is frozen forever; point releases contain corrections and security updates. Titan’s release process must record the exact Debian snapshot date, package manifest, kernel version, and live-build version for each ISO.

## 2. `live-build` and live-image design

### Findings

The Debian `live-build` tooling is organized around high-level commands such as `lb config`, `lb build`, and `lb clean`, with configuration written into a `config/` directory. The trixie `lb_config(1)` documentation exposes the controls Titan needs, including:

- `--distribution` for the Debian suite;
- `--architecture` for the target architecture;
- `--archive-areas` for repository components;
- `--binary-image iso` for an ISO output;
- `--system live` for a live system;
- `--initsystem systemd` for the init system;
- `--firmware-binary` and `--firmware-chroot` for firmware inclusion;
- `--bootloaders` and `--uefi-secure-boot` for boot behavior;
- `--checksums` for generated checksums;
- `--apt-recommends` for controlling dependency expansion;
- `--source` and `--source-images` for source-image generation.

The same manual warns that `lb config` derives defaults from existing saved configuration and that changing settings incrementally can produce an invalid or surprising combination. Titan should generate a complete configuration from a clean build directory, keep the resulting configuration under version control, and use a single authoritative `auto/config` entry point.

The documentation says `--apt-recommends` defaults to true. For Titan, disabling recommendations globally would save space but can remove important desktop integration. The safer approach is to keep dependency resolution correct, start with a deliberately small package list, and disable recommendations only after testing each feature that depends on them.

`live-boot` is for boot-time components of a live image and `live-config` is for late-userspace configuration. `live-config` has a systemd backend and recommends packages such as keyboard configuration, locales, sudo, and user setup. These packages belong in the live-image baseline, but live-only behavior must not be confused with installed-system behavior.

### Titan build policy

The initial build configuration should use the following shape, without executing it yet:

```text
distribution: trixie
architecture: amd64
system: live
binary image: iso
init system: systemd
display stack: Xorg
boot targets: BIOS/legacy plus UEFI, subject to hardware validation
firmware: explicit policy, not live-build default
checksums: sha256
```

The repository should preserve the generated configuration, package lists, hooks, and build metadata. A future build script should fail if it is run outside the intended build environment or if the expected Debian suite is not present.

### Caveats

- `live-build` can produce an ISO, but it does not prove that the ISO boots on the target MacBook.
- `--architecture amd64` does not make the image universally portable across old firmware implementations.
- The current manual documents Secure Boot controls, but the 2010 MacBook target is not a Secure Boot validation target; Titan should test ordinary EFI and legacy paths first.
- The user’s “no ISO yet” instruction remains in force for this phase.

Sources: [`lb_config(1)`](https://manpages.debian.org/trixie/live-build/lb_config.1.en.html), [Debian Live Manual](https://live-team.pages.debian.net/live-manual/), [`live-boot` package](https://packages.debian.org/trixie/live-boot), [`live-config` package](https://packages.debian.org/trixie/live-config), [`live-build(7)` index](https://manpages.debian.org/trixie/live-build/index.html)

## 3. LXQt packaging and service considerations

### Packaging observations

Debian documents three useful LXQt entry points:

- `lxqt-core`: core components only;
- `lxqt`: LXQt components plus recommended desktop packages;
- `task-lxqt-desktop`: a full Debian LXQt desktop task.

The Debian `lxqt` metapackage currently depends on or selects components including `lxqt-core`, `lxqt-powermanagement`, `lxqt-sudo`, `pavucontrol-qt`/`pavucontrol`, `qlipper`/alternatives, `qps`, Qt translations, `qterminal`, and an SDDM theme or another display manager. The package metadata also expresses a choice of window manager rather than forcing one specific window manager. This is useful for integration, but it is broader than Titan’s minimum footprint.

`lxqt-session` is the session manager. `pcmanfm-qt` is the Qt file manager and depends on desktop integration pieces such as D-Bus, desktop-file utilities, Qt libraries, and `lxqt-sudo`; it recommends optional backends and authentication/thumbnail components. These are reasonable additions, but they should be measured rather than blindly pulled into the first image.

### Proposed LXQt baseline

Start with:

```text
lxqt-core
lxqt-session
lxqt-panel
lxqt-config
lxqt-powermanagement
lxqt-policykit
pcmanfm-qt
qterminal
openbox
sddm
xserver-xorg
dbus-user-session
```

Then add the explicitly required integration packages:

```text
network-manager
nm-tray
nm-tray (or another small NetworkManager tray frontend)
pipewire
pipewire-pulse
wireplumber
libspa-0.2-bluetooth
bluez
upower
udisks2
polkitd
```

`sddm` is chosen here because the project already decided on a graphical login and LXQt’s Debian packaging includes SDDM theme alternatives. This is a starting point, not a proven lowest-memory choice. A measurement pass should compare SDDM with a lighter display manager before Alpha 1 is frozen.

### Service implications

- **systemd:** retained as the init/service manager and required by the project decision.
- **NetworkManager:** a root daemon managed as `NetworkManager.service`; the Debian documentation distinguishes the daemon from CLI and GUI frontends. Enable it, but do not add multiple competing network managers.
- **PipeWire/WirePlumber:** user-session multimedia services rather than a single always-on system daemon. WirePlumber depends on PipeWire and optionally supports Bluetooth through `libspa-0.2-bluetooth`.
- **BlueZ:** include the Bluetooth stack because Bluetooth is in scope; enable its service only when the package and hardware are present.
- **CUPS:** include printing support in the image baseline only if the size/performance measurement is acceptable; the daemon should be socket-activated or otherwise disabled when unused. Exact activation behavior must be verified against the selected trixie package version.
- **Upower:** needed for LXQt power/battery integration and useful for the MacBook battery path.
- **udisks2 and polkit:** provide removable-media and authorization integration expected by a desktop session.
- **zram:** configure separately from the desktop session; it is not an LXQt service.
- **fwupd:** defer from the MVP baseline unless the target hardware has a tested, safe firmware-update path. Old Apple hardware is not a good basis for promising firmware-update support.

### Caveats

Package metadata describes declared dependencies and recommendations, not actual idle RAM, startup ordering, or hardware success. Titan must measure a clean boot, a logged-in LXQt session, and the same session with Bluetooth, printing, and audio components exercised.

Sources: [Debian LXQt wiki](https://wiki.debian.org/LXQt), [`lxqt` package](https://packages.debian.org/trixie/lxqt), [`lxqt-session` package](https://packages.debian.org/trixie/lxqt-session), [`pcmanfm-qt` package](https://packages.debian.org/trixie/pcmanfm-qt), [`openbox` package](https://packages.debian.org/trixie/openbox), [`sddm` package](https://packages.debian.org/trixie/sddm), [Debian NetworkManager wiki](https://wiki.debian.org/NetworkManager), [`wireplumber` package](https://packages.debian.org/trixie/wireplumber)

## 4. Firmware policy and `non-free-firmware`

### Debian facts

Debian Policy defines `non-free-firmware` as firmware packages needed to initialize, use, or keep hardware updated, including firmware needed for important functions such as wireless connectivity. The packages may not meet all Debian Free Software Guidelines requirements because their source or modification rights can be restricted.

Debian’s firmware documentation says that, from Debian 12 onward, distributable non-free firmware binaries are in the separate `non-free-firmware` archive component and official installation/live media include those packages. The same documentation explains that firmware detection can be disabled with installer/live boot parameters such as `firmware=never`; this also skips free-firmware detection and installation.

The trixie `lb_config(1)` manual says `--firmware-chroot` defaults to true and warns that firmware packages will only be included when the relevant archive area is enabled. This means a free-firmware-only Titan image must not rely on defaults: it must explicitly define archive areas and firmware settings.

### Titan policy implementation

For the current project decision:

1. Build the first MVP from `main` and `contrib` as needed by selected packages, with free firmware available.
2. Do not include `non-free-firmware` in the default image.
3. Detect and report missing firmware, especially wireless firmware, in the first-run and offline diagnostic tools.
4. Document an opt-in path for users who choose to add `non-free-firmware` after installation, including the licensing/support caveat.
5. Do not call Wi-Fi “supported” until the exact MacBook’s PCI ID, firmware state, association, suspend/resume, and throughput have been tested.

### Important caveat

Debian’s security FAQ says `contrib`, `non-free`, and `non-free-firmware` are not official parts of Debian’s main distribution and are not covered by the Debian Security Team in the same way as `main`. Titan should state this distinction clearly. “Available in Debian” is not equivalent to “covered by Debian main-security support.”

Sources: [Debian Policy §2.2.2](https://www.debian.org/doc/debian-policy/policy.html#s-non-free-firmware), [Debian Firmware wiki](https://wiki.debian.org/Firmware), [Debian Security FAQ](https://www.debian.org/security/faq), [`lb_config(1)` firmware options](https://manpages.debian.org/trixie/live-build/lb_config.1.en.html)

## 5. 2010 13-inch MacBook Pro Linux considerations

### Hardware identity

Apple identifies the 13-inch Mid 2010 model as `MacBookPro7,1`, with model numbers MC375xx/A and MC374xx/A. Apple lists:

- 2.4 or 2.66 GHz Intel Core 2 Duo;
- NVIDIA GeForce 320M with 256 MB shared DDR3 memory;
- 13.3-inch 1280×800 internal display;
- Apple multi-touch trackpad;
- iSight camera;
- 802.11n AirPort Extreme Wi-Fi;
- Bluetooth 2.1 + EDR;
- Gigabit Ethernet;
- 4 GB standard memory and two slots supporting up to 8 GB.

### Linux support implications

#### CPU and architecture

The Core 2 Duo is an amd64-capable target for a 64-bit Linux kernel. This supports the x86-64 MVP decision. The CPU’s age, not package availability, is the likely performance constraint for modern browsers and Qt applications.

#### Graphics

Apple’s 320M is an NVIDIA GPU. Linux’s `nouveau` DRM driver supports a wide range of NVIDIA GPUs, but the kernel documentation does not by itself prove complete acceleration or power-management behavior for this exact Apple-integrated configuration. Titan should treat display modes and basic Xorg output as an early test, while marking 3D acceleration, video decode, external displays, suspend/resume, and thermal behavior as separate tests.

Do not add the proprietary NVIDIA driver to the default image under the current firmware policy. Do not infer success from the presence of the `nouveau` module alone.

#### Trackpad and input

The kernel’s `bcm5974` documentation explicitly covers multi-touch trackpads in MacBook Air and MacBook Pro systems. Kernel input documentation also notes that Apple-style clickpads commonly expose `INPUT_PROP_BUTTONPAD` and that semi-multi-touch behavior is common in 2008–2011 touchpads. This is a good basis for expecting basic pointer input, but actual tap, scrolling, palm rejection, keyboard special keys, and gesture behavior still require hardware tests.

#### Wi-Fi and firmware

Apple identifies the radio as 802.11n AirPort but does not publish the PCI device ID in the technical specification. The Linux wireless documentation explains that Broadcom drivers such as `brcmsmac` and `brcmfmac` require separate firmware files, and it lists unsupported older Broadcom families. The actual MacBook must therefore be inspected with `lspci -nn`/`lsusb` and kernel logs before selecting a driver or deciding whether free firmware is sufficient.

This is the clearest reason to keep the free-firmware-only MVP honest: the unit may boot and display correctly while lacking usable Wi-Fi.

#### Battery, sensors, and power

Apple specifies an integrated battery and MagSafe power, but Apple’s hardware page does not guarantee Linux battery, keyboard-backlight, fan, thermal, or suspend support. These must be tested on the exact machine. Titan should gather `upower`, `/sys/class/power_supply`, ACPI, and kernel log evidence, but mark each result independently.

#### Camera and audio

The iSight camera, speakers, microphone, and combined audio/headphone port are listed by Apple. Their Linux usability depends on the exact USB/audio devices and userspace routing. The MVP should include generic camera/audio diagnostics and report “detected,” “opened successfully,” and “record/playback tested” separately.

### Hardware test matrix for Alpha 1

At minimum, test and record:

```text
model identifier and DMI/SMBIOS data
CPU and RAM
internal panel at 1280x800
external Mini DisplayPort output if available
nouveau/Xorg initialization
keyboard, Fn keys, backlight keys
bcm5974 trackpad: click, tap, scroll, multi-touch
Ethernet
Wi-Fi with free firmware only
Bluetooth discovery and audio/input device pairing
iSight camera capture
speakers, microphone, headphone output
battery and AC transitions
suspend/resume
thermal/fan observations
USB, SD, FireWire, and optical-drive detection where hardware is available
```

Sources: [Apple model identification](https://support.apple.com/en-ie/108052), [Apple technical specifications](https://support.apple.com/en-in/112604), [Kernel `bcm5974` documentation](https://docs.kernel.org/5.3/input/devices/bcm5974.html), [Kernel input event documentation](https://docs.kernel.org/input/event-codes.html), [Linux Wireless Broadcom driver documentation](https://wireless.docs.kernel.org/en/latest/en/users/drivers/brcm80211.html), [Kernel `nouveau` documentation](https://docs.kernel.org/6.15/gpu/nouveau.html)

## 6. Practical amd64 MVP package and service baseline

This is a proposed starting package list, not a claim that every package must ship in Alpha 1. Package names and dependency closure must be resolved against Debian 13.7 at build time.

## 7. Package availability audit

The selected trixie package names were checked against Debian’s official package index during implementation. The audit confirms availability for the most likely build-sensitive additions: `libspa-0.2-bluetooth`, `libinput-tools`, `lxqt-policykit`, `lxqt-powermanagement`, `unattended-upgrades`, `v4l-utils`, `ufw`, `power-profiles-daemon`, `featherpad`, `firefox-esr`, and `brightnessctl`. Availability does not prove that the packages work correctly on the target MacBook or meet the memory budget.

The audit also corrected one naming error: `network-manager-qt` is a source package whose trixie binary outputs are KDE libraries, not a package that should appear in Titan’s live-image package list. Titan uses the available `nm-tray` frontend instead.

Sources: [`libspa-0.2-bluetooth`](https://packages.debian.org/trixie/libspa-0.2-bluetooth), [`libinput-tools`](https://packages.debian.org/trixie/libinput-tools), [`LXQt trixie package index`](https://packages.debian.org/trixie/x11/), [`unattended-upgrades`](https://packages.debian.org/source/stable/unattended-upgrades), [`v4l-utils`](https://packages.debian.org/en/trixie/v4l-utils), [`ufw`](https://packages.debian.org/trixie/ufw), [`power-profiles-daemon`](https://packages.debian.org/trixie/power-profiles-daemon), [`featherpad`](https://packages.debian.org/trixie/featherpad), [`firefox-esr`](https://packages.debian.org/trixie/firefox-esr), and [`brightnessctl`](https://packages.debian.org/trixie/brightnessctl).

### Base/live plumbing

```text
live-boot
live-config
live-config-systemd
live-tools
linux-image-amd64
systemd
dbus
dbus-user-session
sudo
locales
keyboard-configuration
user-setup
```

### Xorg and login

```text
xserver-xorg
xinit
sddm
openbox
```

`xinit` is useful for diagnostics and fallback sessions even when SDDM is present. Keep both a graphical-login path and a documented text-console rescue path.

### LXQt desktop

```text
lxqt-core
lxqt-session
lxqt-panel
lxqt-config
lxqt-powermanagement
lxqt-policykit
pcmanfm-qt
qterminal
```

Add only after measurement:

```text
lxqt-qtplugin
lximage-qt
gvfs-backends
gvfs-fuse
ffmpegthumbnailer
papirus-icon-theme
qlipper
qps
```

### Networking, audio, Bluetooth, and printing

```text
network-manager
nm-tray
nm-tray
pipewire
pipewire-pulse
wireplumber
libspa-0.2-bluetooth
bluez
upower
udisks2
polkitd
cups
cups-client
```

Printer drivers should not be `printer-driver-all` by default; that package can be large. Prefer a small generic baseline and add drivers on demand after the first hardware/use-case survey.

### Memory, diagnostics, and Titan utilities

```text
zram-tools
procps
util-linux
pciutils
usbutils
inxi
dmidecode
hwinfo
lm-sensors
smartmontools
```

`inxi`, `hwinfo`, and `dmidecode` overlap. The final image should choose a compact, scriptable set rather than shipping every diagnostic tool. Titan’s own hardware-report package should consume stable kernel and userspace interfaces, redact identifiers where telemetry/export is involved, and label untested features explicitly.

### Service baseline

Expected enabled or user-session components:

```text
systemd-logind
NetworkManager.service
dbus.service / user D-Bus session
Sddm display-manager.service
PipeWire and WirePlumber user services
bluetooth.service (when Bluetooth hardware is present)
upower.service
zram setup service or generator
```

Expected conditional or deferred components:

```text
cups.service or cups.socket (printing)
fwupd.service (defer until tested)
avahi-daemon (defer unless network discovery is required)
ModemManager (omit unless mobile broadband is in scope)
ssh.service (omit by default)
```

The exact enabled-unit set must be captured from the built image with `systemctl list-unit-files --state=enabled` and `systemctl --failed`. The list above is a design baseline, not a substitute for measurement.

## 7. Recommended Phase 1 decisions

1. **Base:** Debian 13.7 trixie, pinned by codename for the MVP build.
2. **Architecture:** amd64 only for Alpha 1. Treat ARM and 32-bit as separate later build targets.
3. **Desktop:** LXQt core plus a curated package list, not the full `task-lxqt-desktop` task by default.
4. **Display:** Xorg first, with SDDM retained as the initial graphical-login candidate and compared against a lighter alternative during measurements.
5. **Firmware:** free firmware in the default image; do not enable `non-free-firmware` by accident; provide detection, explanation, and documented opt-in installation.
6. **Build:** `live-build` with committed configuration, SHA-256 checksums, explicit bootloader settings, and a recorded package manifest.
7. **MacBook claim level:** “planned target” until the exact MacBookPro7,1 has been boot-tested. Wi-Fi, graphics acceleration, power management, camera, audio, and suspend must be independently verified.
8. **Next implementation step:** create the non-building repository scaffolding for `build/`, `config/`, package lists, hooks, and tests; do not invoke `lb build` yet.

## Source list

- [Debian Releases](https://www.debian.org/releases/index.en.html)
- [Debian 13 “trixie” Release Information](https://www.debian.org/releases/trixie/)
- [Debian 13.7 announcement](https://www.debian.org/News/2026/20260912)
- [Debian Policy Manual, `non-free-firmware`](https://www.debian.org/doc/debian-policy/policy.html#s-non-free-firmware)
- [Debian Firmware wiki](https://wiki.debian.org/Firmware)
- [Debian Security FAQ](https://www.debian.org/security/faq)
- [`lb_config(1)` for Debian trixie](https://manpages.debian.org/trixie/live-build/lb_config.1.en.html)
- [Debian Live Manual](https://live-team.pages.debian.net/live-manual/)
- [`live-boot` package metadata](https://packages.debian.org/trixie/live-boot)
- [`live-config` package metadata](https://packages.debian.org/trixie/live-config)
- [Debian LXQt wiki](https://wiki.debian.org/LXQt)
- [`lxqt` package metadata](https://packages.debian.org/trixie/lxqt)
- [`lxqt-session` package metadata](https://packages.debian.org/trixie/lxqt-session)
- [`pcmanfm-qt` package metadata](https://packages.debian.org/trixie/pcmanfm-qt)
- [`openbox` package metadata](https://packages.debian.org/trixie/openbox)
- [`sddm` package metadata](https://packages.debian.org/trixie/sddm)
- [Debian NetworkManager wiki](https://wiki.debian.org/NetworkManager)
- [`wireplumber` package metadata](https://packages.debian.org/trixie/wireplumber)
- [Apple model identification](https://support.apple.com/en-ie/108052)
- [Apple MacBook Pro (13-inch, Mid 2010) technical specifications](https://support.apple.com/en-in/112604)
- [Linux kernel `bcm5974` documentation](https://docs.kernel.org/5.3/input/devices/bcm5974.html)
- [Linux kernel input event documentation](https://docs.kernel.org/input/event-codes.html)
- [Linux Wireless Broadcom driver documentation](https://wireless.docs.kernel.org/en/latest/en/users/drivers/brcm80211.html)
- [Linux kernel `nouveau` documentation](https://docs.kernel.org/6.15/gpu/nouveau.html)
