#!/usr/bin/env bash
set -euo pipefail

# Security Check Script for Bitcoin Enterprise Suite
# This script runs all security checks locally

echo "=== Bitcoin Enterprise Suite Security Check ==="
echo "Running comprehensive security analysis..."
echo ""

# Check if required tools are installed
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "⚠️  Warning: $1 is not installed. Skipping $2 check."
        return 1
    fi
    return 0
}

# Function to run a check
run_check() {
    local name="$1"
    local command="$2"
    echo "🔍 Running: $name"
    if eval "$command"; then
        echo "✅ $name passed"
    else
        echo "❌ $name failed"
        FAILED_CHECKS+=("$name")
    fi
    echo ""
}

FAILED_CHECKS=()

# 1. Dependency audit
if check_tool "cargo-audit" "dependency audit"; then
    run_check "Dependency Audit" "cargo audit --deny warnings"
fi

# 2. License check
if check_tool "cargo-license" "license compliance"; then
    run_check "License Check" "cargo license --json | grep -qv 'GPL\\|AGPL\\|LGPL' || (echo 'Found copyleft licenses' && false)"
fi

# 3. Cargo deny check
if check_tool "cargo-deny" "cargo deny"; then
    run_check "Cargo Deny" "cargo deny check"
fi

# 4. Format check
run_check "Code Format" "cargo fmt --all -- --check"

# 5. Clippy lints
run_check "Clippy Lints" "cargo clippy --workspace --all-targets --all-features -- -D warnings"

# 6. Security pattern check
echo "🔍 Running: Security Pattern Check"
SECURITY_ISSUES=0

# Check for hardcoded secrets
if grep -r "password\s*=\s*\"" --include="*.rs" libs/ 2>/dev/null; then
    echo "⚠️  Found hardcoded passwords"
    SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

if grep -r "api_key\s*=\s*\"" --include="*.rs" libs/ 2>/dev/null; then
    echo "⚠️  Found hardcoded API keys"
    SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

if grep -r "secret\s*=\s*\"" --include="*.rs" libs/ 2>/dev/null; then
    echo "⚠️  Found hardcoded secrets"
    SECURITY_ISSUES=$((SECURITY_ISSUES + 1))
fi

# Check for unsafe code blocks
UNSAFE_COUNT=$(grep -r "unsafe\s*{" --include="*.rs" libs/ 2>/dev/null | wc -l || echo "0")
if [ "$UNSAFE_COUNT" -gt 0 ]; then
    echo "⚠️  Found $UNSAFE_COUNT unsafe code blocks - please review"
fi

if [ "$SECURITY_ISSUES" -eq 0 ]; then
    echo "✅ Security Pattern Check passed"
else
    echo "❌ Security Pattern Check failed"
    FAILED_CHECKS+=("Security Pattern Check")
fi
echo ""

# 7. Build check
run_check "Build Check" "cargo build --workspace --all-features"

# 8. Test check
run_check "Test Suite" "cargo test --workspace"

# Final report
echo "=== Security Check Summary ==="
if [ ${#FAILED_CHECKS[@]} -eq 0 ]; then
    echo "✅ All security checks passed!"
    exit 0
else
    echo "❌ The following checks failed:"
    for check in "${FAILED_CHECKS[@]}"; do
        echo "  - $check"
    done
    echo ""
    echo "Please fix these issues before committing."
    exit 1
fi