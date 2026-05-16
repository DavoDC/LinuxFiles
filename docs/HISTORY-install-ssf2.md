# SSF2 Install Script - Completed Work

History of improvements to `Scripts/SSF2/INSTALL_SSF2.sh`.

---

## 2026-05-16 - Bidirectional download URL fallback (v1.x vs v.1.x mismatch)

**What:** Added `downloadWithFallback()` helper function. Replaces the bare `wget $dwlURL` call.

**Why it mattered:** The SSF2 CDN has an inconsistent versioning scheme - some files use `v1.4.0.1` in their path, others use `v.1.4.0.1` (dot after v). Confirmed user reports of download failures (CraftGMC 2025-05-24, Adriana 2025-06-14). Rather than hardcoding which form to expect, the fallback tries whatever the download page links to first, then automatically retries with the alternate dot form if wget fails. This handles both the original bug AND any future CDN changes that swap direction.

**Implementation note:** Live CDN testing revealed the bug is bidirectional - at time of writing, Native and Wine Installer URLs use `v1.x.x` (no dot, works) and Wine Portable uses `v.1.x.x` (with dot, works). The fallback toggles to the alternate form in either direction. Tests added in `test_download_fallback.sh` covering 5 scenarios with mocked wget.
