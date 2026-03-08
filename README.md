# AMD ISP4 Camera Driver

Out-of-tree module for the AMD ISP4 camera found in Ryzen AI laptops (e.g., ASUS Zenbook S 16, HP ZBook Ultra G1a).

The driver is not yet merged into mainline Linux. This repo downloads the [patch series](https://lore.kernel.org/linux-media/20260212083426.216430-1-Bin.Du@amd.com/) via `b4` and builds it as a loadable module.

## Requirements

- Linux kernel 6.17.9+ (with `amd_isp4` platform driver, tested up to 6.19.6)
- Kernel headers
- Build tools and `b4`

```bash
# Arch
sudo pacman -S base-devel linux-headers b4

# Ubuntu/Debian
sudo apt install build-essential linux-headers-$(uname -r) b4

# Fedora
sudo dnf install kernel-devel kernel-headers gcc make b4
```

## Install

```bash
make install
```

This downloads the patches, compiles the module, installs it, loads it, and configures it to load at boot.

## After kernel updates

```bash
make install
```

Each kernel version gets its own build directory (`linux-<version>/`). Just run `make install` after updating your kernel.

## Verify

```bash
lsmod | grep amd_capture
v4l2-ctl --list-devices
```
