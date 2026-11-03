# Contributing to Titan OS

## Principles

- Keep the system modular and measurable.
- Prefer Debian-native components over custom replacements.
- Keep scripts idempotent and fail with useful messages.
- Do not claim hardware support without evidence.
- Keep proprietary firmware opt-in and documented.
- Do not add background services without measuring their value.

## Changes

Each change should explain its purpose, package or service impact, and expected memory/performance effect. Configuration changes should include a validation check when practical.

Before submitting a change, run:

```sh
tests/shell/test-zram-files.sh
tests/shell/test-user-tools.sh
tests/shell/test-live-build-config.sh
tests/shell/test-desktop-config.sh
```

If a Debian build environment is available, also build the ISO and attach the build metadata and checksum. Hardware results must include the exact machine, build, kernel, procedure, and outcome.

## Compatibility labels

Use only these labels: confirmed, partially supported, detected but untested, unsupported, and unknown.
