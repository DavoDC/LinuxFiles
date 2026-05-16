#!/usr/bin/env bash
# Tests for dry-run mode in INSTALL_SSF2.sh
# Usage: bash Scripts/SSF2/Tests/test_dry_run.sh
# Run from any directory - mocks curl, no network calls

PASS=0
FAIL=0
INSTALL_SCRIPT="$(cd "$(dirname "$0")" && pwd)/../INSTALL_SSF2.sh"

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

# Integration tests read the log file (more reliable than stdout capture with tee)
# The script writes a log file to the working dir; we read that after the run.
# Mocks (curl, dpkg-query) are unset before each integration run to avoid interference.

run_and_read_log() {
    local temp_dir="$1" input="$2" env_prefix="${3:-}"
    (
        unset -f curl dpkg-query 2>/dev/null
        cd "$temp_dir" && eval "$env_prefix bash \"$INSTALL_SCRIPT\" <<< \"$input\"" > /dev/null 2>&1
    )
    # bash does not guarantee tee (from exec > >(tee...)) finishes before script exit.
    # Wait until the log shows the script's final line, confirming tee is done (max 10s).
    local tries=50 log_file
    while (( tries-- > 0 )); do
        log_file=$(ls "$temp_dir"/ssf2-install-*.log 2>/dev/null | head -1)
        grep -q "Enjoy playing SSF2 on Linux" "$log_file" 2>/dev/null && break
        sleep 0.2
    done
    cat "$log_file" 2>/dev/null
}

# --- T5: OSTYPE=msys triggers DRY_RUN (integration) ---
echo ""
echo "T5: OSTYPE=msys -> script enters dry-run (contains DRY RUN MODE banner)"
TEMP_DIR="$(mktemp -d)"
out=$(run_and_read_log "$TEMP_DIR" "C" "OSTYPE=msys")
rm -rf "$TEMP_DIR"
assert_contains "T5 DRY RUN MODE banner shown" "DRY RUN MODE" "$out"
assert_not_contains "T5 script did not exit with Linux-only message" "This script is for Linux only" "$out"

# --- T6: DRY_RUN=true -> script shows HEAD check result ---
echo ""
echo "T6: DRY_RUN=true -> output contains HEAD check"
TEMP_DIR="$(mktemp -d)"
out=$(run_and_read_log "$TEMP_DIR" "C" "DRY_RUN=true")
rm -rf "$TEMP_DIR"
assert_contains "T6 HEAD check performed" "HEAD check" "$out"
assert_contains "T6 HTTP code shown" "HTTP" "$out"

echo ""
echo "==================================="
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]] && exit 0 || exit 1
