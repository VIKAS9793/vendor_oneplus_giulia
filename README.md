# OnePlus 13R (Giulia) Vendor Tree

This repository contains the vendor blobs for OnePlus 13R (Giulia) needed to build LineageOS or other AOSP-based ROMs.

## Device Specifications

- **Model**: CPH2691
- **Codename**: Giulia
- **System Name**: OnePlus13R
- **System Device**: OP5D3BL1
- **Board**: pineapple
- **Architecture**: arm64
- **Screen Resolution**: 2780x1264 (xxhdpi)

## Directory Structure

```
vendor/
├── app/                    # Vendor applications
│   ├── CACertService/
│   ├── CneApp/
│   └── IWlanService/
├── bin/                    # Binary executables
├── dsp/                    # DSP components
│   ├── adsp/
│   └── cdsp/
├── etc/                    # Configuration files
│   ├── audio/
│   ├── display/
│   ├── nfc/
│   ├── sensor/
│   ├── vintf/
│   └── wifi/
├── firmware/              # Firmware files
│   ├── bt_firmware/
│   └── firmware/
└── lib64/                 # 64-bit libraries
    ├── camera/
    ├── hw/
    └── soundfx/
```

## Recent Changes

### 2024-03-xx Update
- Cleaned up repository structure:
  - Removed unnecessary verification and copy scripts
  - Cleaned up top-level directory
- Fixed corrupted binary file:
  - Replaced 0-byte `libvndfwk_detect_jni.qti_vendor.so` in `vendor/app/CneApp/lib/arm64/`
  - Source: System variant from vendor_blobs
  - Size: ~51KB
- Verified all make files and paths
- Confirmed all binary files are non-corrupted
- Directory structure matches make file definitions

## Build Instructions

1. Clone this repository to `vendor/oneplus/giulia`
2. Include the device in your build:
   ```bash
   # Device configuration
   $(call inherit-product, device/oneplus/giulia/device.mk)
   
   # Vendor blobs
   $(call inherit-product, vendor/oneplus/giulia/giulia-vendor.mk)
   ```

## Vendor Blobs

The vendor tree includes:
- Camera libraries and tuning files
- Display calibration data
- Audio configurations and effects
- Bluetooth and WiFi firmware
- NFC configurations
- Sensor configurations
- Biometric components (fingerprint, face)
- Various system libraries and services

## Important Components

### Critical Libraries
- Qualcomm components (QTI)
- OnePlus specific hardware interfaces
- Camera and display calibration
- Audio processing modules
- Security components

### Configuration Files
- WiFi and Bluetooth configurations
- NFC settings for different regions
- Audio effects and mixer paths
- Display calibration data
- Sensor configurations

## Notes

- All binary files have been verified for integrity
- Paths in make files match the actual directory structure
- No missing or corrupted files remain
- All necessary firmware files are included
- Vendor security patch level: 2025-03-05

## License

This vendor tree is proprietary and is only to be used for building ROMs for OnePlus 13R (Giulia).

## Credits

- OnePlus for the original vendor files
- LineageOS team for the base structure
- Contributors who helped with fixing and organizing the vendor tree 