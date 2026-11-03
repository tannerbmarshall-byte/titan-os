# Continuous integration build

The repository includes a manually triggerable GitHub Actions workflow at `.github/workflows/build-iso.yml`. It installs the Debian Live build tools on an Ubuntu runner, runs `make test`, builds the ISO, records metadata, generates SHA-256 checksums, and uploads the resulting artifacts.

The workflow is not proof of MacBook compatibility. It only proves that the configuration can produce an ISO in the runner environment. The ISO still requires boot testing and the hardware matrix in [HARDWARE.md](HARDWARE.md).

The workflow has not been executed from this local workspace because the project is not connected to a remote repository in the current environment.
