#!/usr/bin/env bash
set -euo pipefail

# Reproducible Build Script for Bitcoin Enterprise Suite
# This script ensures builds are reproducible by setting consistent environment variables

# Set reproducible build environment
export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-$(date +%s)}"
export RUSTFLAGS="-C link-arg=-Wl,--build-id=none -C metadata='' -C extra-filename=''"
export CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-target}"

# Ensure consistent locale
export LC_ALL=C
export LANG=C
export TZ=UTC

# Print build configuration
echo "=== Reproducible Build Configuration ==="
echo "SOURCE_DATE_EPOCH: $SOURCE_DATE_EPOCH"
echo "RUSTFLAGS: $RUSTFLAGS"
echo "CARGO_TARGET_DIR: $CARGO_TARGET_DIR"
echo "======================================="

# Clean previous builds
echo "Cleaning previous builds..."
cargo clean

# Build with consistent settings
echo "Building release artifacts..."
cargo build --release --workspace --locked

# Generate checksums
echo "Generating checksums..."
find "$CARGO_TARGET_DIR/release" -type f \( -name "*.rlib" -o -name "*.so" -o -name "*.dylib" \) -exec sha256sum {} \; | sort > checksums.txt

# Display checksums
echo "=== Build Checksums ==="
cat checksums.txt
echo "======================="

echo "Reproducible build completed successfully!"