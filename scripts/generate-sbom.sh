#!/usr/bin/env bash
set -euo pipefail

# SBOM Generation Script for Bitcoin Enterprise Suite
# Generates Software Bill of Materials in multiple formats

echo "=== Generating Software Bill of Materials (SBOM) ==="
date

OUTPUT_DIR="sbom"
mkdir -p "$OUTPUT_DIR"

# Generate Cargo.lock if it doesn't exist
if [ ! -f "Cargo.lock" ]; then
    echo "Generating Cargo.lock..."
    cargo generate-lockfile
fi

# Generate dependency tree
echo "Generating dependency tree..."
cargo tree --all-features > "$OUTPUT_DIR/dependency-tree.txt"

# Generate JSON format SBOM
echo "Generating JSON SBOM..."
cargo metadata --format-version 1 --all-features > "$OUTPUT_DIR/cargo-metadata.json"

# Generate license information
if command -v cargo-license &> /dev/null; then
    echo "Generating license report..."
    cargo license --json > "$OUTPUT_DIR/licenses.json" || true
    cargo license > "$OUTPUT_DIR/licenses.txt" || true
fi

# Generate audit report
if command -v cargo-audit &> /dev/null; then
    echo "Generating security audit report..."
    cargo audit --json > "$OUTPUT_DIR/audit-report.json" || true
fi

# Create SPDX format SBOM
echo "Creating SPDX SBOM..."
cat > "$OUTPUT_DIR/sbom.spdx" << 'EOF'
SPDXVersion: SPDX-2.3
DataLicense: CC0-1.0
SPDXID: SPDXRef-DOCUMENT
DocumentName: Bitcoin Enterprise Suite SBOM
DocumentNamespace: https://github.com/bitcoin-enterprise-suite/bitcoin-enterprise-suite
Creator: Tool: cargo-sbom-generator
Created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Package Information
PackageName: Bitcoin Enterprise Suite
SPDXID: SPDXRef-Package
PackageVersion: 0.1.0
PackageSupplier: Organization: Fusionpact Technologies Inc.
PackageDownloadLocation: https://github.com/bitcoin-enterprise-suite/bitcoin-enterprise-suite
PackageLicenseConcluded: Apache-2.0
PackageLicenseDeclared: Apache-2.0
PackageCopyrightText: Copyright 2024 Fusionpact Technologies Inc.
FilesAnalyzed: true
PackageVerificationCode: (pending)

# Dependencies will be listed here from Cargo.lock
EOF

# Append dependency information to SPDX
if [ -f "$OUTPUT_DIR/cargo-metadata.json" ]; then
    echo "" >> "$OUTPUT_DIR/sbom.spdx"
    echo "# Dependencies from Cargo.lock" >> "$OUTPUT_DIR/sbom.spdx"
    jq -r '.packages[] | "# Package: \(.name) v\(.version)"' "$OUTPUT_DIR/cargo-metadata.json" >> "$OUTPUT_DIR/sbom.spdx"
fi

# Generate CycloneDX format SBOM (simplified)
echo "Creating CycloneDX SBOM..."
cat > "$OUTPUT_DIR/sbom.cyclonedx.json" << 'EOF'
{
  "bomFormat": "CycloneDX",
  "specVersion": "1.4",
  "version": 1,
  "metadata": {
    "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
    "tools": [
      {
        "vendor": "Bitcoin Enterprise Suite",
        "name": "cargo-sbom-generator",
        "version": "1.0.0"
      }
    ],
    "component": {
      "type": "application",
      "bom-ref": "bitcoin-enterprise-suite",
      "name": "Bitcoin Enterprise Suite",
      "version": "0.1.0",
      "licenses": [
        {
          "license": {
            "id": "Apache-2.0"
          }
        }
      ]
    }
  },
  "components": []
}
EOF

# Create summary report
echo "Creating SBOM summary..."
cat > "$OUTPUT_DIR/SBOM_SUMMARY.md" << EOF
# Software Bill of Materials (SBOM) Summary

**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")  
**Project:** Bitcoin Enterprise Suite  
**Version:** 0.1.0  
**License:** Apache-2.0  

## Contents

- **dependency-tree.txt**: Complete dependency tree with all features
- **cargo-metadata.json**: Full Cargo metadata in JSON format
- **licenses.json**: License information for all dependencies
- **licenses.txt**: Human-readable license list
- **audit-report.json**: Security audit results
- **sbom.spdx**: SPDX format SBOM
- **sbom.cyclonedx.json**: CycloneDX format SBOM

## Statistics

- Total dependencies: $(grep -c "^├──\|^└──" "$OUTPUT_DIR/dependency-tree.txt" 2>/dev/null || echo "N/A")
- Direct dependencies: $(grep -c "^├──\|^└──" "$OUTPUT_DIR/dependency-tree.txt" | head -20 | wc -l 2>/dev/null || echo "N/A")

## Verification

To verify the SBOM contents:
\`\`\`bash
cd sbom/
sha256sum * > checksums.sha256
sha256sum -c checksums.sha256
\`\`\`

EOF

# Generate checksums
echo "Generating checksums..."
cd "$OUTPUT_DIR"
sha256sum * > checksums.sha256
cd ..

echo "=== SBOM Generation Complete ==="
echo "Files generated in: $OUTPUT_DIR/"
ls -la "$OUTPUT_DIR/"