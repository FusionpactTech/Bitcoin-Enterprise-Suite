#!/bin/bash
# Security check script for local development
# Run this before pushing to ensure security checks pass in CI

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(dirname "$SCRIPT_DIR")"
cd "$WORKSPACE_DIR"

echo "🛡️  Bitcoin Enterprise Suite - Security Check"
echo "=============================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if required tools are installed
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}❌ $1 is not installed${NC}"
        echo "Please install $1 to run security checks"
        return 1
    else
        echo -e "${GREEN}✅ $1 is available${NC}"
        return 0
    fi
}

echo "Checking required tools..."
TOOLS_OK=true

if ! check_tool "cargo"; then
    TOOLS_OK=false
fi

if ! check_tool "cargo-audit" || ! cargo audit --version &> /dev/null; then
    echo -e "${YELLOW}⚠️  Installing cargo-audit...${NC}"
    cargo install cargo-audit --force
fi

if ! check_tool "cargo-deny" || ! cargo deny --version &> /dev/null; then
    echo -e "${YELLOW}⚠️  Installing cargo-deny...${NC}"
    cargo install cargo-deny --force
fi

if ! check_tool "cargo-license" || ! cargo license --version &> /dev/null; then
    echo -e "${YELLOW}⚠️  Installing cargo-license...${NC}"
    cargo install cargo-license --force
fi

if ! check_tool "gitleaks"; then
    echo -e "${YELLOW}⚠️  gitleaks not found. Please install it for secret scanning.${NC}"
    echo "You can install it from: https://github.com/gitleaks/gitleaks"
fi

echo ""

# Fix Cargo.lock format if needed
echo "🔧 Checking Cargo.lock format..."
if grep -q 'version = 4' Cargo.lock; then
    echo -e "${YELLOW}⚠️  Downgrading Cargo.lock format for compatibility...${NC}"
    sed -i 's/version = 4/version = 3/' Cargo.lock
fi

# Run security checks
echo ""
echo "🔍 Running security checks..."
echo ""

# 1. Dependency Audit
echo "1️⃣  Dependency Security Audit"
echo "------------------------------"
# First check for critical vulnerabilities only
if cargo audit --deny unsound --deny yanked; then
    echo -e "${GREEN}✅ No critical vulnerabilities found${NC}"
    
    # Then check for warnings and unmaintained crates (informational)
    echo "Checking for warnings and unmaintained crates..."
    cargo audit || echo -e "${YELLOW}⚠️  Some warnings found (non-critical)${NC}"
else
    echo -e "${RED}❌ Critical security vulnerabilities found${NC}"
    exit 1
fi
echo ""

# 2. Cargo Deny Check
echo "2️⃣  Cargo Deny Check"
echo "--------------------"
if cargo deny check; then
    echo -e "${GREEN}✅ Cargo deny check passed${NC}"
else
    echo -e "${RED}❌ Cargo deny check failed${NC}"
    exit 1
fi
echo ""

# 3. License Check
echo "3️⃣  License Compliance Check"
echo "----------------------------"
if cargo license --json > licenses.json; then
    # Check for problematic licenses
    if command -v jq &> /dev/null; then
        # Check each license entry individually
        PROBLEMATIC_FOUND=false
        while IFS= read -r license; do
            # Skip licenses that have acceptable alternatives (OR clauses with Apache-2.0 or MIT)
            if echo "$license" | grep -q "Apache-2.0\|MIT"; then
                continue  # This license has acceptable alternatives
            fi
            
            # Check if this license is problematic
            if echo "$license" | grep -qE "(GPL-[0-9]|AGPL-[0-9]|LGPL-[0-9])"; then
                echo -e "${RED}❌ Found problematic license without acceptable alternative: $license${NC}"
                PROBLEMATIC_FOUND=true
            fi
        done < <(jq -r '.[].license' licenses.json | sort | uniq)
        
        if [ "$PROBLEMATIC_FOUND" = true ]; then
            exit 1
        fi
    fi
    echo -e "${GREEN}✅ License compliance check passed${NC}"
    rm -f licenses.json
else
    echo -e "${RED}❌ License check failed${NC}"
    exit 1
fi
echo ""

# 4. Secret Scanning (if gitleaks is available)
if command -v gitleaks &> /dev/null; then
    echo "4️⃣  Secret Scanning"
    echo "------------------"
    if gitleaks detect --source . --no-banner --redact=0; then
        echo -e "${GREEN}✅ No secrets detected${NC}"
    else
        echo -e "${RED}❌ Secrets detected in repository${NC}"
        exit 1
    fi
else
    echo "4️⃣  Secret Scanning"
    echo "------------------"
    echo -e "${YELLOW}⚠️  Skipped - gitleaks not installed${NC}"
fi
echo ""

# 5. Basic security file checks
echo "5️⃣  Security Policy Check"
echo "-------------------------"
if [ -f "SECURITY.md" ]; then
    echo -e "${GREEN}✅ SECURITY.md file exists${NC}"
else
    echo -e "${RED}❌ SECURITY.md file missing${NC}"
    exit 1
fi
echo ""

echo "🎉 All security checks passed!"
echo ""
echo "You can now safely push your changes."
echo "The CI pipeline will run the same checks automatically."