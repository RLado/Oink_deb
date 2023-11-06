#!/bin/bash
set -e

VERSION="1.0"
REV="1"
ARCH=$(dpkg --print-architecture)

# This script is used to build a Debian package from source
git clone --depth 1 --branch v$VERSION.$REV https://github.com/RLado/Oink.git

# Create a temporary directory
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"
mkdir -p oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN

# Build and copy files
cd Oink
make build
make install DESTDIR=../oink_"$VERSION"-"$REV"_"$ARCH"
cd ..

# Create the control file
echo "
Package: oink
Version: $VERSION.$REV
Architecture: $ARCH
Maintainer: Ricard Lado <ricard@lado.one>
Description: A lightweight DDNS client for Porkbun
    Oink! is an unofficial DDNS client for porkbun.com built in Go
" > oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN/control

# Create conffiles
echo "/etc/oink_ddns/config.json" > oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN/conffiles

# Set correct permissions
chmod 0755 oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN
chmod 0644 oink_"$VERSION"-"$REV"_"$ARCH"/DEBIAN/*
chmod 0755 oink_"$VERSION"-"$REV"_"$ARCH"/usr
chmod 0700 oink_"$VERSION"-"$REV"_"$ARCH"/etc/oink_ddns
chmod 0600 oink_"$VERSION"-"$REV"_"$ARCH"/etc/oink_ddns/config.json

# Create the package
dpkg-deb --build --root-owner-group oink_"$VERSION"-"$REV"_"$ARCH"

# Clean up
rm -rf oink_"$VERSION"-"$REV"_"$ARCH"
rm -rf Oink
