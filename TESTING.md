# Titan OS Testing Plan

## Test stages

The repository currently provides static checks for shell syntax, required package entries, service enablement, zram configuration, first-run behavior markers, hardware-report safeguards, desktop keybindings, package-list consistency, and an MVP source audit. Run `make test` and `make audit`. These checks do not replace a Debian build or real hardware test.

Run `titan-performance-report --save PATH` inside the built live system to collect the repeatable baseline. It records observations only; it does not automatically suspend the machine or claim that the target hardware is supported.

### Configuration checks

- Validate shell scripts and configuration syntax.
- Verify package lists and service policies.
- Verify branding files and live-build configuration.
- Confirm scripts are idempotent where practical.

### ISO checks

- Build the ISO from a clean environment.
- Record build inputs and output checksums.
- Inspect the package list and enabled services.
- Validate the ISO filesystem and checksum with `make validate-iso`.
- Boot the ISO in a virtual machine when useful for fast feedback.

### MacBook checks

Physical hardware testing is required for any MacBook-specific compatibility claim. Tests must cover boot, display, input, networking, audio, webcam, battery, controls, suspend/resume, and thermal behavior.

## Performance measurements

Record:

- Idle RAM, including measurement method
- Idle CPU
- Boot time
- Disk footprint
- Startup services
- Application launch responsiveness
- zram and disk-swap behavior

The initial idle-memory goal is approximately 300–500 MB on a minimal installation. This is a measured target, not an assumed result.

## Functional checks

- Network availability
- Audio input and output
- Bluetooth
- Printing
- Display resolution and external display
- Brightness controls
- Volume controls
- Keyboard and trackpad behavior
- Battery reporting
- Suspend and resume
- Suspend diagnostics before and after the sleep cycle
- Offline diagnostic report
- Firewall defaults
- Update controls and recovery record

## Reporting rules

Every result must identify the tested hardware, build, date, procedure, and outcome. Unknown or untested behavior must remain visible in documentation.
