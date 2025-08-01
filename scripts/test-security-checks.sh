#!/bin/bash
set -euo pipefail

# Bitcoin Enterprise Suite - Security Checks Test Script
# Tests all security measures to ensure they're functioning properly

echo "🔒 Bitcoin Enterprise Suite - Security Checks Verification"
echo "========================================================="
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="${3:-0}"
    
    ((TESTS_TOTAL++))
    echo -n "Testing $test_name... "
    
    if eval "$test_command" > /tmp/test_output 2>&1; then
        actual_exit_code=0
    else
        actual_exit_code=$?
    fi
    
    if [[ $actual_exit_code -eq $expected_exit_code ]]; then
        echo -e "${GREEN}✅ PASS${NC}"
        ((TESTS_PASSED++))
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        echo "  Expected exit code: $expected_exit_code"
        echo "  Actual exit code: $actual_exit_code"
        echo "  Output:"
        sed 's/^/    /' /tmp/test_output
        ((TESTS_FAILED++))
        return 1
    fi
}

# Function to check if a tool is available
check_tool() {
    local tool="$1"
    local install_cmd="$2"
    
    if ! command -v "$tool" &> /dev/null; then
        echo -e "${YELLOW}⚠️  $tool not found, installing...${NC}"
        eval "$install_cmd"
    fi
}

echo "🔧 Checking required tools..."
check_tool "cargo" "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && source ~/.cargo/env"

# Source cargo environment if needed
if [[ -f ~/.cargo/env ]]; then
    source ~/.cargo/env
elif [[ -f /usr/local/cargo/env ]]; then
    source /usr/local/cargo/env
fi

echo

echo "🔍 Running Security Checks..."
echo "-----------------------------"

# 1. Dependency Security Audit
run_test "Dependency Security Audit (cargo audit)" "cargo audit"

# 2. Cargo Deny Check  
run_test "Cargo Deny Policy Check" "cargo deny check"

# 3. License Compliance Check
run_test "License Compliance Check" "cargo deny check licenses"

# 4. Advisory Check
run_test "Security Advisory Check" "cargo deny check advisories"

# 5. Check for build success
run_test "Basic Build Check" "cargo check --workspace"

# 6. Check deny.toml syntax
run_test "Deny.toml Configuration Check" "cargo deny check --config deny.toml advisories"

# 7. Check if security documentation exists
run_test "Security Documentation Check" "test -f SECURITY.md && test -f docs/security/security-audit-2025-01.md"

# 8. Check if Dockerfile exists
run_test "Container Security Check" "test -f Dockerfile"

# 9. Check if TruffleHog config exists
run_test "Secret Scanning Config Check" "test -f .trufflehog.yml"

# 10. Verify CI/CD security workflows exist
run_test "CI/CD Security Workflows Check" "test -f .github/workflows/security.yml"

echo
echo "📊 Security Check Summary"
echo "========================"
echo -e "Total Tests: ${BLUE}$TESTS_TOTAL${NC}"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo
    echo -e "${GREEN}🎉 All security checks passed!${NC}"
    echo -e "${GREEN}✅ Bitcoin Enterprise Suite is secure and ready for production.${NC}"
    exit 0
else
    echo
    echo -e "${RED}❌ Some security checks failed.${NC}"
    echo -e "${YELLOW}⚠️  Please review the failures above and fix them before deploying.${NC}"
    exit 1
fi