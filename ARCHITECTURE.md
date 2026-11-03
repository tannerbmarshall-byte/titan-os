# Titan OS Architecture

## MVP target

Titan OS Alpha 1 targets x86-64 computers, with priority given to the 2010 13-inch MacBook Pro. The initial build is pinned to Debian 13.7 “trixie” and amd64. ARM and 32-bit x86 will use separate future images and share the project’s scripts and packaging where practical.

## System layers

1. **Foundation** — Debian Stable, standard Debian kernel, systemd, Xorg.
2. **Desktop** — a curated LXQt installation based on `lxqt-core`, with light and dark themes, minimal effects, Openbox, and a graphical login through SDDM.
3. **Core services** — NetworkManager, PipeWire, power management, Bluetooth, printing, and firewall defaults.
4. **Memory policy** — automatic zram, disk swap when available, and measured swappiness behavior.
5. **Titan utilities** — first-run setup, hardware information, diagnostics, rescue tools, and compatibility reporting.
6. **Build system** — Debian `live-build` with architecture-specific configuration separated from shared configuration.

## Initial package baseline

The first package list will be deliberately curated rather than using the full LXQt desktop task. The initial baseline is:

```text
lxqt-core lxqt-session lxqt-panel lxqt-config lxqt-powermanagement
lxqt-policykit pcmanfm-qt qterminal openbox sddm xserver-xorg
network-manager nm-tray pipewire pipewire-pulse wireplumber
bluez libspa-0.2-bluetooth upower udisks2 polkitd
```

The list is provisional. Dependency closure, idle RAM, startup services, printing, Bluetooth, and audio behavior must be measured before Alpha 1 is frozen.

## Default experience

The live image will provide a lightweight browser, terminal, file manager, text editor, settings tools, hardware information, diagnostics, Bluetooth support, and printer support. It will not include an office suite by default.

Audio and network controls will use PipeWire/WirePlumber, `pavucontrol-qt`, and `nm-tray`; these are user-facing controls over the underlying services, not replacements for them.

The first-run setup will configure the user experience, explain firmware limitations, offer telemetry consent, and provide controls for updates and privacy.

## Security and recovery

- Create and use a normal non-root user.
- Enable a basic firewall with desktop-friendly defaults.
- Make automatic updates user-controllable.
- Record enough update state to support recovery after a failed update.
- Include a text-based rescue mode and offline diagnostic report.
- Do not install proprietary firmware automatically.

## Telemetry

Telemetry is opt-in only. It is limited to hardware and performance information, remains local by default, and is manually exportable. Titan OS will not require or operate a remote telemetry server for the MVP.

## Compatibility status

Every hardware feature must be marked as one of:

- Confirmed
- Partially supported
- Detected but untested
- Unsupported
- Unknown

“Confirmed” requires repeatable evidence from the target hardware.
