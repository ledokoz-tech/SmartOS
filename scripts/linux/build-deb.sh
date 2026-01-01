#!/bin/bash

# SmartOS DEB Package Build Script

set -e

# Package information
PACKAGE_NAME="smartos"
VERSION="1.0.0"
ARCH="amd64"
MAINTAINER="Ledokoz <contact@ledokoz.com>"
DESCRIPTION="Smart Home Operating System"

# Create build directory
BUILD_DIR="/tmp/smartos-deb-build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create debian package structure
DEB_DIR="$BUILD_DIR/debian"
mkdir -p "$DEB_DIR/DEBIAN"
mkdir -p "$DEB_DIR/usr/bin"
mkdir -p "$DEB_DIR/usr/share/smartos"
mkdir -p "$DEB_DIR/usr/share/applications"
mkdir -p "$DEB_DIR/usr/share/icons/hicolor/256x256/apps"

# Copy files
cp "../core/config/configuration.yaml" "$DEB_DIR/usr/share/smartos/"
cp "smartos.desktop" "$DEB_DIR/usr/share/applications/"
cp "../../../core/branding/smartos_icon.png" "$DEB_DIR/usr/share/icons/hicolor/256x256/apps/smartos.png"

# Create executable script
cat > "$DEB_DIR/usr/bin/smartos" << 'EOF'
#!/bin/bash
# SmartOS launcher script

# Find the SmartOS installation
SMARTOS_DIR="/opt/smartos"

if [ -d "$SMARTOS_DIR" ]; then
    cd "$SMARTOS_DIR"
    python3 -m homeassistant --config ~/.smartos/config
else
    echo "SmartOS not found. Please install SmartOS first."
    exit 1
fi
EOF

chmod +x "$DEB_DIR/usr/bin/smartos"

# Create control file
cat > "$DEB_DIR/DEBIAN/control" << EOF
Package: $PACKAGE_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
Depends: python3, python3-pip, python3-venv
EOF

# Create postinst script
cat > "$DEB_DIR/DEBIAN/postinst" << 'EOF'
#!/bin/bash
# Post-installation script

# Create smartos user if it doesn't exist
if ! id -u smartos > /dev/null 2>&1; then
    useradd --system --shell /bin/bash --home /opt/smartos --create-home smartos
fi

# Set permissions
chown -R smartos:smartos /opt/smartos
chmod +x /usr/bin/smartos

# Create default configuration directory
mkdir -p /home/smartos/.smartos/config
cp /usr/share/smartos/configuration.yaml /home/smartos/.smartos/config/ 2>/dev/null || true
chown -R smartos:smartos /home/smartos/.smartos

echo "SmartOS installed successfully!"
echo "Run 'smartos' to start the application."
EOF

chmod +x "$DEB_DIR/DEBIAN/postinst"

# Build the package
cd "$BUILD_DIR"
dpkg-deb --build debian
mv debian.deb "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Move to output directory
mkdir -p "../../../scripts/linux"
cp "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb" "../../../scripts/linux/"

echo "DEB package built: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
