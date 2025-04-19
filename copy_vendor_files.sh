#!/bin/bash

# Source and destination paths
SRC_DIR="C:/Users/vikas/Downloads/vendor_blobs"
DEST_DIR="C:/Users/vikas/Downloads/vendor_oneplus_giulia"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to create directory if it doesn't exist
make_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo -e "${GREEN}Created directory:${NC} $1"
    fi
}

# Function to copy file with validation
copy_file() {
    local src=$1
    local dest=$2
    
    if [ ! -f "$src" ]; then
        echo -e "${RED}Error: Source file not found:${NC} $src"
        return 1
    fi
    
    cp "$src" "$dest"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Copied:${NC} $src -> $dest"
    else
        echo -e "${RED}Failed to copy:${NC} $src"
        return 1
    fi
}

# Function to copy directory with validation
copy_dir() {
    local src=$1
    local dest=$2
    
    if [ ! -d "$src" ]; then
        echo -e "${RED}Error: Source directory not found:${NC} $src"
        return 1
    fi
    
    cp -r "$src" "$dest"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Copied directory:${NC} $src -> $dest"
    else
        echo -e "${RED}Failed to copy directory:${NC} $src"
        return 1
    fi
}

echo "Starting vendor files copy..."
echo "============================"

# WiFi and Bluetooth files
echo -e "\n${YELLOW}Copying WiFi and Bluetooth files:${NC}"
make_dir "${DEST_DIR}/proprietary/vendor/etc/wifi"
copy_file "${SRC_DIR}/odm/etc/wifi.cfg" "${DEST_DIR}/proprietary/vendor/etc/wifi/"
copy_dir "${SRC_DIR}/odm/etc/wifi/" "${DEST_DIR}/proprietary/vendor/etc/wifi/"
copy_dir "${SRC_DIR}/odm/etc/bt" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/bluetooth.cfg" "${DEST_DIR}/proprietary/vendor/etc/"

# Audio files
echo -e "\n${YELLOW}Copying Audio files:${NC}"
make_dir "${DEST_DIR}/proprietary/vendor/etc/audio"
copy_file "${SRC_DIR}/odm/etc/mixer_paths.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/audio_effects.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/virtual_audio_policy_configuration.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/binaural_record_algo_coeffs.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_dir "${SRC_DIR}/odm/etc/audio/" "${DEST_DIR}/proprietary/vendor/etc/audio/"

# Media files
echo -e "\n${YELLOW}Copying Media files:${NC}"
make_dir "${DEST_DIR}/proprietary/vendor/etc"
copy_file "${SRC_DIR}/odm/etc/media_codecs_c2.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/media_codecs_dolby_vision.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/media_codecs_vendor_oplus.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/media_profiles_V1_0.xml" "${DEST_DIR}/proprietary/vendor/etc/"

# Sensor files
echo -e "\n${YELLOW}Copying Sensor files:${NC}"
make_dir "${DEST_DIR}/proprietary/vendor/etc/sensor"
copy_file "${SRC_DIR}/odm/etc/sensor.cfg" "${DEST_DIR}/proprietary/vendor/etc/"
copy_dir "${SRC_DIR}/odm/etc/sensor/" "${DEST_DIR}/proprietary/vendor/etc/sensor/"
copy_file "${SRC_DIR}/odm/etc/apdr.conf" "${DEST_DIR}/proprietary/vendor/etc/"

# Display configs
echo -e "\n${YELLOW}Copying Display configs:${NC}"
make_dir "${DEST_DIR}/proprietary/vendor/etc/display"
cp "${SRC_DIR}/odm/etc/p_3_a0020_"* "${DEST_DIR}/proprietary/vendor/etc/display/" 2>/dev/null || echo -e "${YELLOW}Warning: No p_3_a0020 display configs found${NC}"
cp "${SRC_DIR}/odm/etc/samsung1024_s6e3hc3_"* "${DEST_DIR}/proprietary/vendor/etc/display/" 2>/dev/null || echo -e "${YELLOW}Warning: No samsung1024_s6e3hc3 display configs found${NC}"

# NFC config
echo -e "\n${YELLOW}Copying NFC configs:${NC}"
make_dir "${DEST_DIR}/proprietary/vendor/etc/nfc"
copy_file "${SRC_DIR}/odm/etc/libnfc-nci.conf" "${DEST_DIR}/proprietary/vendor/etc/"
copy_dir "${SRC_DIR}/odm/etc/nfc/" "${DEST_DIR}/proprietary/vendor/etc/nfc/"

# GPS configs
echo -e "\n${YELLOW}Copying GPS configs:${NC}"
copy_file "${SRC_DIR}/odm/etc/gps.conf" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/izat.conf" "${DEST_DIR}/proprietary/vendor/etc/"

# Power and resource management
echo -e "\n${YELLOW}Copying Power and Resource Management files:${NC}"
copy_file "${SRC_DIR}/odm/etc/power_stats_config.xml" "${DEST_DIR}/proprietary/vendor/etc/"
copy_file "${SRC_DIR}/odm/etc/resourcemanager.xml" "${DEST_DIR}/proprietary/vendor/etc/"

echo -e "\n${GREEN}Files copied successfully!${NC}"
echo -e "${YELLOW}Please run verify_vendor_files.sh to verify the copied files.${NC}" 