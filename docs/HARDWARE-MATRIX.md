# Titan OS hardware matrix

This matrix is intentionally conservative. A feature remains **untested** until it has evidence from the exact hardware and Titan OS build.

## Target machine

| Field | Planned target | Status |
|---|---|---|
| Apple model | MacBookPro7,1 / 2010 13-inch MacBook Pro | identified from Apple specifications; exact unit not inspected |
| CPU | 2.66 GHz Intel Core 2 Duo | target specification; Linux behavior untested |
| Graphics | NVIDIA GeForce 320M | detected/driver behavior untested |
| Display | 1280×800 internal panel | display behavior untested |
| Memory | up to 8 GB | target specification; memory measurements untested |
| Boot | EFI and legacy paths | untested |

## Feature status

| Feature | Status | Evidence required |
|---|---|---|
| Basic x86-64 boot | untested | boot log from the target machine |
| EFI boot | untested | successful EFI boot and repeat reboot |
| Legacy boot | untested | successful legacy boot where available |
| Internal display | untested | Xorg session at native resolution |
| NVIDIA graphics | untested | driver logs, display behavior, and acceleration test |
| External display | untested | Mini DisplayPort connection and display test |
| Apple keyboard | untested | key and modifier test |
| Brightness keys | untested | key event and brightness change |
| Apple trackpad | untested | click, tap, scroll, and palm-rejection test |
| Ethernet | untested | link, DHCP, and sustained transfer |
| Wi-Fi | untested | exact PCI ID, firmware state, association, and transfer |
| Bluetooth | untested | discovery and device pairing |
| Speakers | untested | playback test |
| Microphone | untested | recording and playback test |
| Headphone jack | untested | plug/unplug and output routing |
| iSight camera | untested | V4L2 device and capture test |
| Battery reporting | untested | AC transitions and capacity reporting |
| Power profiles | untested | profile availability and behavior |
| Suspend/resume | untested | before/after diagnostic reports and repeated cycles |
| Thermal/fan behavior | untested | temperature and fan observations under load |

## Status rules

- **Confirmed** requires repeatable evidence on the exact target hardware.
- **Partially supported** means the feature works with a documented limitation.
- **Detected but untested** means the system sees a device but behavior is not confirmed.
- **Unsupported** requires a reproducible failure with the relevant configuration.
- **Unknown** means there is not enough evidence to classify the feature.
