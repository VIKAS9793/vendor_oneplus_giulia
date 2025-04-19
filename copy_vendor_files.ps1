# Source and destination paths
$SRC_DIR = "C:\Users\vikas\Downloads\vendor_blobs"
$DEST_DIR = "C:\Users\vikas\Downloads\vendor_oneplus_giulia"

# Colors for output
$RED = [System.ConsoleColor]::Red
$GREEN = [System.ConsoleColor]::Green
$YELLOW = [System.ConsoleColor]::Yellow

# Function to create directory if it doesn't exist
function Make-Dir {
    param([string]$path)
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Created directory: $path" -ForegroundColor $GREEN
    }
}

# Function to copy file with validation
function Copy-FileWithValidation {
    param([string]$src, [string]$dest)
    
    if (-not (Test-Path $src)) {
        Write-Host "Error: Source file not found: $src" -ForegroundColor $RED
        return $false
    }
    
    try {
        Copy-Item $src $dest -Force
        Write-Host "Copied: $src -> $dest" -ForegroundColor $GREEN
        return $true
    }
    catch {
        Write-Host "Failed to copy: $src" -ForegroundColor $RED
        Write-Host $_.Exception.Message -ForegroundColor $RED
        return $false
    }
}

# Function to copy directory with validation
function Copy-DirWithValidation {
    param([string]$src, [string]$dest)
    
    if (-not (Test-Path $src)) {
        Write-Host "Error: Source directory not found: $src" -ForegroundColor $RED
        return $false
    }
    
    try {
        Copy-Item $src $dest -Recurse -Force
        Write-Host "Copied directory: $src -> $dest" -ForegroundColor $GREEN
        return $true
    }
    catch {
        Write-Host "Failed to copy directory: $src" -ForegroundColor $RED
        Write-Host $_.Exception.Message -ForegroundColor $RED
        return $false
    }
}

Write-Host "Starting vendor files copy..."
Write-Host "============================" -ForegroundColor $YELLOW

# WiFi and Bluetooth files
Write-Host "`nCopying WiFi and Bluetooth files:" -ForegroundColor $YELLOW
Make-Dir "$DEST_DIR\proprietary\vendor\etc\wifi"
Copy-FileWithValidation "$SRC_DIR\odm\etc\wifi.cfg" "$DEST_DIR\proprietary\vendor\etc\wifi"
Copy-Item "$SRC_DIR\odm\etc\wifi\*" "$DEST_DIR\proprietary\vendor\etc\wifi" -Force -Recurse
Copy-Item "$SRC_DIR\odm\etc\bt" "$DEST_DIR\proprietary\vendor\etc" -Force -Recurse
Copy-FileWithValidation "$SRC_DIR\odm\etc\bluetooth.cfg" "$DEST_DIR\proprietary\vendor\etc"

# Audio files
Write-Host "`nCopying Audio files:" -ForegroundColor $YELLOW
Make-Dir "$DEST_DIR\proprietary\vendor\etc\audio"
Copy-FileWithValidation "$SRC_DIR\odm\etc\mixer_paths.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\audio_effects.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\virtual_audio_policy_configuration.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\binaural_record_algo_coeffs.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-Item "$SRC_DIR\odm\etc\audio\*" "$DEST_DIR\proprietary\vendor\etc\audio" -Force -Recurse

# Media files
Write-Host "`nCopying Media files:" -ForegroundColor $YELLOW
Make-Dir "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\media_codecs_c2.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\media_codecs_dolby_vision.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\media_codecs_vendor_oplus.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\media_profiles_V1_0.xml" "$DEST_DIR\proprietary\vendor\etc"

# Sensor files
Write-Host "`nCopying Sensor files:" -ForegroundColor $YELLOW
Make-Dir "$DEST_DIR\proprietary\vendor\etc\sensor"
Copy-FileWithValidation "$SRC_DIR\odm\etc\sensor.cfg" "$DEST_DIR\proprietary\vendor\etc"
Copy-Item "$SRC_DIR\odm\etc\sensor\*" "$DEST_DIR\proprietary\vendor\etc\sensor" -Force -Recurse
Copy-FileWithValidation "$SRC_DIR\odm\etc\apdr.conf" "$DEST_DIR\proprietary\vendor\etc"

# Display configs
Write-Host "`nCopying Display configs:" -ForegroundColor $YELLOW
Make-Dir "$DEST_DIR\proprietary\vendor\etc\display"
Copy-Item "$SRC_DIR\odm\etc\p_3_a0020_*" "$DEST_DIR\proprietary\vendor\etc\display" -Force
Copy-Item "$SRC_DIR\odm\etc\samsung1024_s6e3hc3_*" "$DEST_DIR\proprietary\vendor\etc\display" -Force

# NFC config
Write-Host "`nCopying NFC configs:" -ForegroundColor $YELLOW
Make-Dir "$DEST_DIR\proprietary\vendor\etc\nfc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\libnfc-nci.conf" "$DEST_DIR\proprietary\vendor\etc"
Copy-Item "$SRC_DIR\odm\etc\nfc\*" "$DEST_DIR\proprietary\vendor\etc\nfc" -Force -Recurse

# GPS configs
Write-Host "`nCopying GPS configs:" -ForegroundColor $YELLOW
Copy-FileWithValidation "$SRC_DIR\odm\etc\gps.conf" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\izat.conf" "$DEST_DIR\proprietary\vendor\etc"

# Power and resource management
Write-Host "`nCopying Power and Resource Management files:" -ForegroundColor $YELLOW
Copy-FileWithValidation "$SRC_DIR\odm\etc\power_stats_config.xml" "$DEST_DIR\proprietary\vendor\etc"
Copy-FileWithValidation "$SRC_DIR\odm\etc\resourcemanager.xml" "$DEST_DIR\proprietary\vendor\etc"

Write-Host "`nFiles copied successfully!" -ForegroundColor $GREEN
Write-Host "Please run verify_vendor_files.ps1 to verify the copied files." -ForegroundColor $YELLOW 