# Debian build container

This is an optional reproducible builder for hosts that have Docker or Podman. It does not run on the current Mac because neither runtime is installed there.

From the Titan OS project root:

```sh
docker build -t titan-os-builder build/container
docker run --rm --privileged \
  -v "$PWD:/workspace" \
  titan-os-builder build
```

The container is isolated from the host installation, but live-build may need elevated container privileges to create loopback filesystems. Review the runtime’s security model before use.
