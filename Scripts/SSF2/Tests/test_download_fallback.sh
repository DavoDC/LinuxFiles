#!/usr/bin/env bash
# Tests for downloadWithFallback() in INSTALL_SSF2.sh
# Usage: bash test_download_fallback.sh
# Run from any directory - tests use mocked wget

PASS=0
FAIL=0

# --- mock wget: controlled by MOCK_WGET_FAIL_URLS ---
MOCK_WGET_FAIL_URLS=()
wget() {
    local url="$1"
    for fail_url in "${MOCK_WGET_FAIL_URLS[@]}"; do
        if [[ "$url" == "$fail_url" ]]; then
            echo "[MOCK] wget failed for: $url"
            return 8
        fi
    done
    echo "[MOCK] wget succeeded for: $url"
    return 0
}
export -f wget

# --- source the function under test ---
INSTALL_SCRIPT="$(dirname "$0")/../INSTALL_SSF2.sh"
# Extract only downloadWithFallback (source the whole file is too invasive)
# Instead, define the function inline - kept in sync with INSTALL_SSF2.sh manually
source <(awk '/^function downloadWithFallback/,/^\}/' "$INSTALL_SCRIPT")

# --- helpers ---
assert() {
    local label="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then
        echo "  PASS: $label"
        ((PASS++))
    else
        echo "  FAIL: $label (expected=$expected, got=$actual)"
        ((FAIL++))
    fi
}

# --- tests ---

echo "=== downloadWithFallback tests ==="
echo ""

echo "T1: URL with v.digit succeeds on first try - no fallback"
MOCK_WGET_FAIL_URLS=()
url="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaWindows.32bit.v.1.4.0.1.portable.zip"
downloadWithFallback "$url" > /dev/null 2>&1
assert "T1 exit 0" "0" "$?"

echo ""
echo "T2: URL with vdigit succeeds on first try - no fallback"
MOCK_WGET_FAIL_URLS=()
url="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaLinux.v1.4.0.1.tar"
downloadWithFallback "$url" > /dev/null 2>&1
assert "T2 exit 0" "0" "$?"

echo ""
echo "T3: URL with vdigit (no dot) fails - fallback with dot succeeds"
original="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaLinux.v1.4.0.1.tar"
MOCK_WGET_FAIL_URLS=("$original")
downloadWithFallback "$original" > /dev/null 2>&1
assert "T3 exit 0 (fallback v.digit worked)" "0" "$?"

echo ""
echo "T4: URL with v.digit fails - fallback without dot succeeds"
original="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaWindows.32bit.v.1.4.0.1.portable.zip"
fallback="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaWindows.32bit.v1.4.0.1.portable.zip"
MOCK_WGET_FAIL_URLS=("$original")
downloadWithFallback "$original" > /dev/null 2>&1
assert "T4 exit 0 (fallback vdigit worked)" "0" "$?"

echo ""
echo "T5: Both URL forms fail - non-zero exit returned"
original="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaLinux.v1.4.0.1.tar"
fallback="https://cdn.supersmashflash.com/ssf2/downloads/fc7d249c/SSF2BetaLinux.v.1.4.0.1.tar"
MOCK_WGET_FAIL_URLS=("$original" "$fallback")
downloadWithFallback "$original" > /dev/null 2>&1
result=$?
assert "T5 non-zero exit" "1" "$((result != 0 ? 1 : 0))"

echo ""
echo "==================================="
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
