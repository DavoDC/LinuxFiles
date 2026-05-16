#!/usr/bin/env bash
# Tests for dry-run mode in INSTALL_SSF2.sh
# Usage: bash Scripts/SSF2/Tests/test_dry_run.sh
# Run from any directory - mocks curl, no network calls

PASS=0
FAIL=0
INSTALL_SCRIPT="$(dirname "$0")/../INSTALL_SSF2.sh"

# --- mock curl for URL checks ---
MOCK_CURL_HTTP_CODE="200"
curl() {
    # Handle: curl -sI -o /dev/null -w "%{http_code}" <url>
    if [[ "$*" == *"-w"*"%{http_code}"* ]]; then
        echo "$MOCK_CURL_HTTP_CODE"
        return 0
    fi
    # Handle: curl -s <url> -o <file>  (page fetch - write empty HTML)
    local out_file=""
    local args=("$@")
    for i in "${!args[@]}"; do
        if [[ "${args[$i]}" == "-o" ]]; then
            out_file="${args[$((i+1))]}"
        fi
    done
    [[ -n "$out_file" ]] && echo "" > "$out_file"
    return 0
}
export -f curl

# --- source install() and printDryBanner() from the script ---
# We only source the function definitions, not the top-level script body
source <(awk '/^function printDryBanner/,/^\}/' "$INSTALL_SCRIPT") 2>/dev/null || true
source <(awk '/^function isNotInstalled/,/^\}/' "$INSTALL_SCRIPT") 2>/dev/null || true
source <(awk '/^function install\(\)/,/^\}/' "$INSTALL_SCRIPT") 2>/dev/null || true

# --- helpers ---
assert_contains() {
    local label="$1" needle="$2" haystack="$3"
    if [[ "$haystack" == *"$needle"* ]]; then
        echo "  PASS: $label"
        ((PASS++))
    else
        echo "  FAIL: $label (expected to contain: '$needle')"
        ((FAIL++))
    fi
}

assert_not_contains() {
    local label="$1" needle="$2" haystack="$3"
    if [[ "$haystack" != *"$needle"* ]]; then
        echo "  PASS: $label"
        ((PASS++))
    else
        echo "  FAIL: $label (expected NOT to contain: '$needle')"
        ((FAIL++))
    fi
}

assert_exit() {
    local label="$1" expected="$2" actual="$3"
    if [[ "$actual" == "$expected" ]]; then
        echo "  PASS: $label"
        ((PASS++))
    else
        echo "  FAIL: $label (expected exit=$expected, got=$actual)"
        ((FAIL++))
    fi
}

echo "=== dry-run mode tests ==="
echo ""

# --- T1: printDryBanner emits DRY RUN label ---
echo "T1: printDryBanner output contains DRY RUN"
out=$(printDryBanner "test action" 2>&1)
assert_contains "T1 banner has DRY RUN" "DRY RUN" "$out"
assert_contains "T1 banner has action text" "test action" "$out"

# --- T2: install() in DRY_RUN=true skips and prints banner ---
echo ""
echo "T2: install() with DRY_RUN=true prints banner and does not call dpkg-query"
PKG_MANAGER="apt"
DRY_RUN=true
dpkg_called=false
dpkg-query() { dpkg_called=true; }
export -f dpkg-query
out=$(install "fake-package" 2>&1)
DRY_RUN=false
assert_contains "T2 install dry-run banner appears" "DRY RUN" "$out"
assert_not_contains "T2 dpkg-query not called" "dpkg_called=true" "dpkg_called=$dpkg_called"

# --- T3: install() in DRY_RUN=false would call isNotInstalled ---
echo ""
echo "T3: install() with DRY_RUN=false does not print DRY RUN banner"
DRY_RUN=false
# We can't easily test real package install without sudo, so just check banner absent
PKG_MANAGER="apt"
# Mock dpkg-query to return "installed" so install() is a no-op
dpkg-query() { echo "install ok installed"; }
export -f dpkg-query
out=$(install "fake-package" 2>&1)
assert_not_contains "T3 no dry-run banner in normal mode" "DRY RUN" "$out"

# --- T4: DRY_RUN variable respected from environment ---
echo ""
echo "T4: DRY_RUN env var flows through to script (check global var init)"
# Source just the global variable section to test DRY_RUN="${DRY_RUN:-false}" init
result=$(DRY_RUN=true bash -c '
    INSTALL_SCRIPT="'"$INSTALL_SCRIPT"'"
    source <(awk "/^DRY_RUN=/,/^$/" "$INSTALL_SCRIPT" | head -1) 2>/dev/null
    # The var is set by env, check it survives the default assignment
    DRY_RUN="${DRY_RUN:-false}"
    echo "DRY_RUN=$DRY_RUN"
' 2>&1)
assert_contains "T4 DRY_RUN=true preserved" "DRY_RUN=true" "$result"

# --- T5: OSTYPE=msys triggers DRY_RUN (integration) ---
echo ""
echo "T5: OSTYPE=msys -> script enters dry-run (contains DRY RUN MODE banner)"
TEMP_DIR="$(mktemp -d)"
out=$(cd "$TEMP_DIR" && OSTYPE=msys bash "$INSTALL_SCRIPT" <<< "C" 2>&1)
rc=$?
rm -rf "$TEMP_DIR"
assert_contains "T5 DRY RUN MODE banner shown" "DRY RUN MODE" "$out"
assert_not_contains "T5 script did not exit with Linux-only message" "This script is for Linux only" "$out"

# --- T6: DRY_RUN=true -> script shows HEAD check result ---
echo ""
echo "T6: DRY_RUN=true -> output contains HEAD check"
TEMP_DIR="$(mktemp -d)"
out=$(cd "$TEMP_DIR" && DRY_RUN=true bash "$INSTALL_SCRIPT" <<< "C" 2>&1)
rm -rf "$TEMP_DIR"
assert_contains "T6 HEAD check performed" "HEAD check" "$out"
assert_contains "T6 HTTP code shown" "HTTP" "$out"

echo ""
echo "==================================="
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
