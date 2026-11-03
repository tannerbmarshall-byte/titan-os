FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        debootstrap \
        dosfstools \
        grub-efi-amd64-bin \
        grub-pc-bin \
        isolinux \
        live-build \
        make \
        syslinux-common \
        xorriso \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
ENTRYPOINT ["make"]
CMD ["build"]
