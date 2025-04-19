# Destination path
$VENDOR_DIR = "C:\Users\vikas\Downloads\vendor_oneplus_giulia\proprietary\vendor"

# Colors for output
$RED = [System.ConsoleColor]::Red
$GREEN = [System.ConsoleColor]::Green
$YELLOW = [System.ConsoleColor]::Yellow

function Check-File {
    param([string]$path)
    
    if (Test-Path $path -PathType Leaf) {
        Write-Host "✓ Found: $path" -ForegroundColor $GREEN
        return $true
    }
    else {
        Write-Host "✗ Missing: $path" -ForegroundColor $RED
        return $false
    }
}

function Check-Dir {
    param([string]$path)
    
    if (Test-Path $path -PathType Container) {
        Write-Host "✓ Directory exists: $path" -ForegroundColor $GREEN
        return $true
    }
    else {
        Write-Host "✗ Missing directory: $path" -ForegroundColor $RED
        return $false
    }
}

function Check-XmlContent {
    param(
        [string]$file,
        [string]$tag,
        [string]$expected
    )
    
    if (Select-String -Path $file -Pattern "<$tag.*>" -Quiet) {
        Write-Host "✓ Found $tag in: $file" -ForegroundColor $GREEN
    }
    else {
        Write-Host "! Missing $tag in: $file" -ForegroundColor $YELLOW
    }
}

Write-Host "Starting vendor files verification..."
Write-Host "======================================" -ForegroundColor $YELLOW

# Check WiFi files
Write-Host "`nChecking WiFi Configuration Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\wifi\wifi.cfg"
Check-File "$VENDOR_DIR\etc\wifi\cnss_diag.conf"
Check-File "$VENDOR_DIR\etc\wifi\regdb.bin"

# Check Bluetooth files
Write-Host "`nChecking Bluetooth Configuration Files:" -ForegroundColor $YELLOW
Check-Dir "$VENDOR_DIR\etc\bt"
Check-File "$VENDOR_DIR\etc\bluetooth.cfg"

# Check Audio files
Write-Host "`nChecking Audio Configuration Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\mixer_paths.xml"
if (Check-File "$VENDOR_DIR\etc\audio_effects.xml") {
    Check-XmlContent "$VENDOR_DIR\etc\audio_effects.xml" "effects" ""
    Check-XmlContent "$VENDOR_DIR\etc\audio_effects.xml" "libraries" ""
}
Check-File "$VENDOR_DIR\etc\virtual_audio_policy_configuration.xml"
Check-File "$VENDOR_DIR\etc\binaural_record_algo_coeffs.xml"

# Check Media files
Write-Host "`nChecking Media Configuration Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\media_codecs_c2.xml"
Check-File "$VENDOR_DIR\etc\media_codecs_dolby_vision.xml"
Check-File "$VENDOR_DIR\etc\media_codecs_vendor_oplus.xml"
if (Check-File "$VENDOR_DIR\etc\media_profiles_V1_0.xml") {
    Check-XmlContent "$VENDOR_DIR\etc\media_profiles_V1_0.xml" "VideoEncoderCap" ""
    Check-XmlContent "$VENDOR_DIR\etc\media_profiles_V1_0.xml" "AudioEncoderCap" ""
}

# Check Sensor files
Write-Host "`nChecking Sensor Configuration Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\sensor.cfg"
Check-Dir "$VENDOR_DIR\etc\sensor"
Check-File "$VENDOR_DIR\etc\apdr.conf"

# Check Display configs
Write-Host "`nChecking Display Configuration Files:" -ForegroundColor $YELLOW
Check-Dir "$VENDOR_DIR\etc\display"
$p3Files = Get-ChildItem "$VENDOR_DIR\etc\display\p_3_a0020_*" -ErrorAction SilentlyContinue
if ($p3Files) {
    Write-Host "✓ Found p_3_a0020 display configs" -ForegroundColor $GREEN
} else {
    Write-Host "✗ Missing p_3_a0020 display configs" -ForegroundColor $RED
}
$samsungFiles = Get-ChildItem "$VENDOR_DIR\etc\display\samsung1024_s6e3hc3_*" -ErrorAction SilentlyContinue
if ($samsungFiles) {
    Write-Host "✓ Found samsung1024_s6e3hc3 display configs" -ForegroundColor $GREEN
} else {
    Write-Host "✗ Missing samsung1024_s6e3hc3 display configs" -ForegroundColor $RED
}

# Check NFC config
Write-Host "`nChecking NFC Configuration Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\libnfc-nci.conf"
Check-Dir "$VENDOR_DIR\etc\nfc"

# Check GPS configs
Write-Host "`nChecking GPS Configuration Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\gps.conf"
Check-File "$VENDOR_DIR\etc\izat.conf"

# Check Power and Resource Management
Write-Host "`nChecking Power and Resource Management Files:" -ForegroundColor $YELLOW
Check-File "$VENDOR_DIR\etc\power_stats_config.xml"
Check-File "$VENDOR_DIR\etc\resourcemanager.xml"

Write-Host "`nVerification complete!" -ForegroundColor $YELLOW 