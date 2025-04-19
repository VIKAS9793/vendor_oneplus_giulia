# Vendor Tree for OnePlus 13R (Giulia)

This repository contains the vendor tree for OnePlus 13R (Giulia), including proprietary blobs and makefiles necessary for building the device.

## Git LFS

This repository uses Git Large File Storage (LFS) for managing large binary files. Before cloning, make sure you have Git LFS installed:

```bash
# Install Git LFS
git lfs install

# Clone the repository
git clone https://github.com/VIKAS9793/vendor_oneplus_giulia.git -b lineage-22.2
cd vendor_oneplus_giulia

# Pull LFS files
git lfs pull
```

If you don't have Git LFS installed, you can get it from:
- Windows: Download from https://git-lfs.github.com
- Linux: `sudo apt install git-lfs` (Ubuntu/Debian) or `sudo yum install git-lfs` (Fedora)
- macOS: `brew install git-lfs`

## Structure

```
vendor/oneplus/giulia/
├── proprietary/          # Proprietary blobs
│   ├── vendor/          # Vendor specific files
│   │   ├── bin/        # Binary executables
│   │   ├── etc/        # Configuration files
│   │   ├── firmware/   # Firmware files
│   │   ├── lib64/      # 64-bit libraries
│   │   └── dsp/        # DSP related files
│   ├── odm/            # ODM specific files
│   ├── system_ext/     # System extension files
│   └── my_product/     # OnePlus specific product files
├── giulia-vendor.mk     # Main vendor makefile
└── giulia-vendor-blobs.mk # Vendor blobs makefile

```

## Features

- Complete vendor binary support
- Hardware Abstraction Layer (HAL) services
- Camera configurations
- Audio configurations
- Firmware files
- System libraries
- VINTF manifest files
- OnePlus specific components

## Components

### Essential Hardware Components
- TimeService
- IWlanService
- CneApp
- Sensor Service

### Supported HALs
- Audio (v7.0)
- Bluetooth (v1.1)
- Camera (v2.4)
- Display
- DRM
- Gatekeeper
- GPS/GNSS
- Health
- Keymaster
- Media
- Neural Networks
- Power
- RIL
- Sensors
- USB
- WiFi

## Device Information

- Model: CPH2691
- System Name: OnePlus13R
- Device: OP5D3BL1
- Board: pineapple
- Security Patch Level: 2024-01-05

## Latest Changes

- Updated vendor blobs structure
- Added missing VINTF manifest files
- Updated HAL versions to latest supported
- Added OnePlus specific configurations
- Organized makefiles for better maintainability
- Added support for new hardware features
- Updated security patch level
- Added proper firmware file handling
- Enhanced audio and camera configurations

## Building

This vendor tree is designed to be used with the Android Open Source Project (AOSP) build system. It should be placed in:

```
vendor/oneplus/giulia/
```

## Notes

- Some firmware files might need to be obtained from the device
- Certain OnePlus-specific features require additional configuration
- Security patch level is maintained at 2024-01-05

## Credits

Maintained by: VIKAS9793 (vikassahani17@gmail.com)

## License

```
# Copyright (C) 2024 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
``` 
