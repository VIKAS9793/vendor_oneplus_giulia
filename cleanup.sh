#!/bin/bash

echo "Starting cleanup of OnePlus-specific components..."

# Base directory
VENDOR_DIR="$(pwd)"
PROP_DIR="$VENDOR_DIR/proprietary"

# Function to remove files/directories if they exist
remove_if_exists() {
    if [ -e "$1" ]; then
        rm -rf "$1"
        echo "Removed: $1"
    fi
}

# 1. Remove OnePlus-specific VINTF manifests
echo "Removing OnePlus VINTF manifests..."
find "$PROP_DIR" -type f -name "manifest_oplus_*.xml" -delete
find "$PROP_DIR" -type f -name "oplus_aidl_*.xml" -delete
find "$PROP_DIR" -type f -name "*_oplus_*.xml" -delete

# 2. Remove OnePlus-specific directories
echo "Removing OnePlus-specific directories..."
OPLUS_DIRS=(
    "$PROP_DIR/system_ext/oplus"
    "$PROP_DIR/system_ext/oplusex"
    "$PROP_DIR/my_product/oplus"
    "$PROP_DIR/my_product/oplusex"
    "$PROP_DIR/odm/etc/oplus"
    "$PROP_DIR/vendor/etc/oplus"
    "$PROP_DIR/my_product/cust"
    "$PROP_DIR/my_product/decouping_wallpaper"
    "$PROP_DIR/my_product/product_overlay"
)

for dir in "${OPLUS_DIRS[@]}"; do
    remove_if_exists "$dir"
done

# 3. Remove OnePlus-specific init scripts
echo "Removing OnePlus init scripts..."
find "$PROP_DIR" -type f -name "init.oplus*.rc" -delete

# 4. Remove OnePlus-specific apps
echo "Removing OnePlus-specific apps..."
OPLUS_APPS=(
    "$PROP_DIR/vendor/app/OplusEngineerMode"
    "$PROP_DIR/vendor/app/OplusGames"
    "$PROP_DIR/vendor/app/OplusCamera"
    "$PROP_DIR/vendor/app/OplusGallery"
    "$PROP_DIR/vendor/app/OplusSettings"
)

for app in "${OPLUS_APPS[@]}"; do
    remove_if_exists "$app"
done

# 5. Remove OnePlus-specific libraries
echo "Removing OnePlus-specific libraries..."
find "$PROP_DIR" -type f -name "libopluscare.so" -delete
find "$PROP_DIR" -type f -name "liboplus*.so" -delete

# 6. Remove OnePlus-specific configurations
echo "Removing OnePlus-specific configurations..."
find "$PROP_DIR" -type f -name "*oplus*.xml" -delete
find "$PROP_DIR" -type f -name "*oneplus*.conf" -delete

# 7. Remove OnePlus camera-specific files
echo "Removing OnePlus camera-specific files..."
find "$PROP_DIR" -type f -path "*/camera/oplus*" -delete

# 8. Remove OnePlus-specific overlays
echo "Removing OnePlus-specific overlays..."
find "$PROP_DIR/my_product/overlay" -type f -name "*oplus*" -delete
find "$PROP_DIR/my_product/overlay" -type f -name "*oneplus*" -delete

# 9. Remove OnePlus-specific firmware
echo "Removing OnePlus-specific firmware..."
find "$PROP_DIR" -type f -name "alipay.*" -delete

# 10. Clean up vendor makefiles
echo "Cleaning up vendor makefiles..."
sed -i '/oplus/d' "$VENDOR_DIR/giulia-vendor-blobs.mk"
sed -i '/oneplus/d' "$VENDOR_DIR/giulia-vendor-blobs.mk"

echo "Cleanup complete!"
echo "Please review the changes and test the build." 