# Traffic Watch Fleet

Personal NixOS configurations for a distributed traffic monitoring system using an Intel NUC controller and Raspberry Pi edge devices.

This repository contains the infrastructure configurations for the workshop paper implementation at https://github.com/rawalcher/rust-traffic-watch

## Architecture

- **Controller**: Intel NUC running traffic analysis and coordination
- **Edge Devices**: Raspberry Pi 4 variants (1GB, 2GB, 8GB) with ML inference capabilities

## Hardware Configurations

### Controller (NUC)
- Intel NUC with x86_64 architecture
- Control ports: 9090 (control), 9091 (data), 9092 (receiver)

### Edge Devices (Raspberry Pi 4)
- ARM64 architecture with specialized kernels
- Python ML stack including PyTorch, OpenCV, and Ultralytics YOLO
- Memory-optimized configurations per variant

## Quick Start

### Build Configurations

```bash
# Build NUC controller image
nix build .#nixosConfigurations.nuc.config.system.build.toplevel

# Build Pi images
nix build .#nixosConfigurations.pi4-1gb.config.system.build.toplevel
nix build .#nixosConfigurations.pi4-2gb.config.system.build.toplevel
nix build .#nixosConfigurations.pi4-8gb.config.system.build.toplevel
```

### Deploy to Target

```bash
# Copy configuration to target device
nixos-rebuild switch --flake .#<hostname> --target-host nixos@<ip-address>
```

## Network Configuration

All devices use NetworkManager with DHCP. Firewall allows:
- SSH (port 22)
- Controller communication (ports 9090-9092)

## Security

- SSH key-based authentication via agenix secrets
- Separate deploy keys for nixos and traffic repositories
- Firewall protection with minimal exposed ports

## Development

Default user is `nixos` with sudo privileges. Each device includes development tools:
- Git, nano, wget, curl
- System monitoring: htop, tmux
- Architecture-specific toolchains

## Memory Management

- **1GB Pi**: 7GB swap file, restricted journal logging
- **2GB Pi**: 6GB swap file, restricted journal logging  
- **8GB Pi**: No additional swap needed
- **NUC**: 8GB swap file for intensive processing

## State Version

All configurations target NixOS 23.11 stable.
