# SSF2 Install Script - Completed Work

History of improvements to `Scripts/SSF2/INSTALL_SSF2.sh`.

---

## 2026-05-16 - Windows dry-run mode

**What:** Instead of exiting when `OSTYPE` is `msys` or `cygwin`, the script now enters a dry-run mode. Also activatable on any platform via `DRY_RUN=true bash ./INSTALL_SSF2.sh`. In dry-run mode:
- Shows a prominent `*** DRY RUN MODE ***` banner at startup and before every skipped step
- Shows the version selection menu and captures the user's choice as normal
- Uses curl (not wget) to fetch the real SSF2 download page and extract the exact download URL
- HEAD-checks the URL with `curl -sI` and reports the HTTP status
- Prints what every install step would do (install packages, extract archives, run wine) but skips execution
- Full log output still works (tee works on Windows)
- All Linux behavior unchanged - all guards use `if/else` so Linux paths are identical to before

**Why it mattered:** Developers and contributors on Windows had no way to test the script logic or verify that URL extraction was working. The script would just exit immediately. Now anyone on Windows can simulate a full install run, check the menu flow, and verify URLs are reachable before testing on a real Linux machine.

**Tests added:** `test_dry_run.sh` with 10 tests covering banner output, install() skip behavior, env var propagation, and full-script integration (T5/T6 make real network calls to supersmashflash.com). Key implementation note: bash process substitution `exec > >(tee ...)` is non-deterministic on cygwin - tests poll for the final log line rather than assuming the file is complete.

---

## 2026-05-16 - Timestamped run logging

**What:** Added `exec > >(tee -a "$LOG_FILE") 2>&1` redirect after the starting message. Every run creates `./ssf2-install-YYYYMMDD-HHMMSS.log` in the current directory.

**Why it mattered:** Users hitting install failures had no way to share diagnostic output. Now they can attach the log file when reporting issues. Terminal display is unchanged - tee duplicates output to file transparently.

---

## 2026-05-16 - Bidirectional download URL fallback (v1.x vs v.1.x mismatch)

**What:** Added `downloadWithFallback()` helper function. Replaces the bare `wget $dwlURL` call.

**Why it mattered:** The SSF2 CDN has an inconsistent versioning scheme - some files use `v1.4.0.1` in their path, others use `v.1.4.0.1` (dot after v). Confirmed user reports of download failures (CraftGMC 2025-05-24, Adriana 2025-06-14). Rather than hardcoding which form to expect, the fallback tries whatever the download page links to first, then automatically retries with the alternate dot form if wget fails. This handles both the original bug AND any future CDN changes that swap direction.

**Implementation note:** Live CDN testing revealed the bug is bidirectional - at time of writing, Native and Wine Installer URLs use `v1.x.x` (no dot, works) and Wine Portable uses `v.1.x.x` (with dot, works). The fallback toggles to the alternate form in either direction. Tests added in `test_download_fallback.sh` covering 5 scenarios with mocked wget.
