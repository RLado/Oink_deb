#!/bin/bash
set -e

VERSION="0.1"
REV="0"
ARCH=$(dpkg --print-architecture)

# This script is used to build a Debian package from source
git clone --depth 1 --branch v$VERSION.$REV https://github.com/RLado/Oink.git

# Build
cd Oink
make build

cd ..

# Create the control file
echo "
Package: oink
Version: $VERSION.$REV
Architecture: $ARCH
Maintainer: Ricard Lado <ricard@lado.one>
Description: A lightweight DDNS client for Porkbun
    Oink! is an unofficial DDNS client for porkbun.com built in Go
" > control

# Create a temporary directory
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"/usr/bin
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"/etc/oink_ddns/
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"/lib/systemd/system/

# Copy files
cp Oink/oink oink_"$VERSION"-"$REV"_"$ARCH"/usr/bin/
cp Oink/config/config.json oink_"$VERSION"-"$REV"_"$ARCH"/etc/oink_ddns/
cp Oink/config/oink_ddns.service oink_"$VERSION"-"$REV"_"$ARCH"/lib/systemd/system/
cp control  oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN/

# Create the package
dpkg-deb --build --root-owner-group oink_"$VERSION"-"$REV"_"$ARCH"

# Clean up
rm -rf oink_"$VERSION"-"$REV"_"$ARCH"
rm -rf Oink
rm control
