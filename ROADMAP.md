# Titan OS Roadmap

## Phase 0 — Planning and project setup

Status: **Complete**

- Inspect the existing Desktop workspace
- Choose the Debian/LXQt architecture
- Define the x86-64 MVP scope
- Record ARM and 32-bit as future targets
- Define evidence requirements for hardware support
- Create the isolated project directory and planning documents

## Phase 1 — Research and architecture validation

Status: **Complete**

- Verify current Debian Stable live-build capabilities
- Research LXQt package and service requirements
- Define the initial package allowlist and denylist
- Define zram, swap, firewall, update, and telemetry policies
- Research MacBook hardware identifiers and known Linux support
- Choose the first browser and minimal default applications
- Write the build and testing specifications
- Record verified findings in `docs/research/phase-1.md`

## Phase 2 — Alpha 1 live ISO

Status: **In progress**

- Create live-build configuration
- Add LXQt, Xorg, branding, and login configuration
- Add zram and swap setup
- Add NetworkManager, PipeWire, Bluetooth, printing, power, and firewall configuration
- Add first-run setup and system information tools
- Add diagnostics and text rescue mode
- Add zram service enablement and configuration validation
- Add first-run setup, hardware reporting, desktop controls, branding, and release automation
- Build an x86-64 ISO

## Phase 3 — Validation

Status: **Not started**

- Validate the ISO in a virtual machine when useful
- Test booting on the target MacBook
- Measure RAM, CPU, boot time, disk usage, and service count
- Test networking, audio, display, brightness, keys, camera, battery, suspend, and resume
- Publish compatibility status and test evidence

## Phase 4 — Documentation and release

Status: **Not started**

- Complete build and test documentation
- Publish checksums and a signed release manifest
- Publish known-hardware compatibility information
- Label untested and experimental features
- Release Titan OS Alpha 1 only after evidence review

## Later work

- Graphical installer
- ARM image
- 32-bit x86 image
- Additional desktop choices
- Broader recovery and rollback support
