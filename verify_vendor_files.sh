#!/bin/bash

# Destination path
VENDOR_DIR="C:/Users/vikas/Downloads/vendor_oneplus_giulia/proprietary/vendor"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓ Found:${NC} $1"
        return 0
    else
        echo -e "${RED}✗ Missing:${NC} $1"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓ Directory exists:${NC} $1"
        return 0
    else
        echo -e "${RED}✗ Missing directory:${NC} $1"
        return 1
    fi
}

check_xml_content() {
    local file=$1
    local tag=$2
    local expected=$3
    
    if grep -q "<$tag>" "$file"; then
        echo -e "${GREEN}✓ Found $tag in:${NC} $file"
    else
        echo -e "${YELLOW}! Missing $tag in:${NC} $file"
    fi
}

echo "Starting vendor files verification..."
echo "======================================"

# Check WiFi files
echo -e "\n${YELLOW}Checking WiFi Configuration Files:${NC}"
check_file "${VENDOR_DIR}/etc/wifi/wifi.cfg"
check_file "${VENDOR_DIR}/etc/wifi/cnss_diag.conf"
check_file "${VENDOR_DIR}/etc/wifi/regdb.bin"

# Check Bluetooth files
echo -e "\n${YELLOW}Checking Bluetooth Configuration Files:${NC}"
check_dir "${VENDOR_DIR}/etc/bt"
check_file "${VENDOR_DIR}/etc/bluetooth.cfg"

# Check Audio files
echo -e "\n${YELLOW}Checking Audio Configuration Files:${NC}"
check_file "${VENDOR_DIR}/etc/mixer_paths.xml"
if check_file "${VENDOR_DIR}/etc/audio_effects.xml"; then
    check_xml_content "${VENDOR_DIR}/etc/audio_effects.xml" "effects" ""
    check_xml_content "${VENDOR_DIR}/etc/audio_effects.xml" "libraries" ""
fi
check_file "${VENDOR_DIR}/etc/virtual_audio_policy_configuration.xml"
check_file "${VENDOR_DIR}/etc/binaural_record_algo_coeffs.xml"

# Check Media files
echo -e "\n${YELLOW}Checking Media Configuration Files:${NC}"
check_file "${VENDOR_DIR}/etc/media_codecs_c2.xml"
check_file "${VENDOR_DIR}/etc/media_codecs_dolby_vision.xml"
check_file "${VENDOR_DIR}/etc/media_codecs_vendor_oplus.xml"
if check_file "${VENDOR_DIR}/etc/media_profiles_V1_0.xml"; then
    check_xml_content "${VENDOR_DIR}/etc/media_profiles_V1_0.xml" "VideoEncoderCap" ""
    check_xml_content "${VENDOR_DIR}/etc/media_profiles_V1_0.xml" "AudioEncoderCap" ""
fi

# Check Sensor files
echo -e "\n${YELLOW}Checking Sensor Configuration Files:${NC}"
check_file "${VENDOR_DIR}/etc/sensor.cfg"
check_dir "${VENDOR_DIR}/etc/sensor"
check_file "${VENDOR_DIR}/etc/apdr.conf"

# Check Display configs
echo -e "\n${YELLOW}Checking Display Configuration Files:${NC}"
check_dir "${VENDOR_DIR}/etc/display"
ls "${VENDOR_DIR}/etc/display/p_3_a0020_"* >/dev/null 2>&1 && \
    echo -e "${GREEN}✓ Found p_3_a0020 display configs${NC}" || \
    echo -e "${RED}✗ Missing p_3_a0020 display configs${NC}"
ls "${VENDOR_DIR}/etc/display/samsung1024_s6e3hc3_"* >/dev/null 2>&1 && \
    echo -e "${GREEN}✓ Found samsung1024_s6e3hc3 display configs${NC}" || \
    echo -e "${RED}✗ Missing samsung1024_s6e3hc3 display configs${NC}"

# Check NFC config
echo -e "\n${YELLOW}Checking NFC Configuration Files:${NC}"
check_file "${VENDOR_DIR}/etc/libnfc-nci.conf"
check_dir "${VENDOR_DIR}/etc/nfc"

# Check GPS configs
echo -e "\n${YELLOW}Checking GPS Configuration Files:${NC}"
check_file "${VENDOR_DIR}/etc/gps.conf"
check_file "${VENDOR_DIR}/etc/izat.conf"

# Check Power and Resource Management
echo -e "\n${YELLOW}Checking Power and Resource Management Files:${NC}"
check_file "${VENDOR_DIR}/etc/power_stats_config.xml"
check_file "${VENDOR_DIR}/etc/resourcemanager.xml"

echo -e "\n${YELLOW}Verification complete!${NC}" 