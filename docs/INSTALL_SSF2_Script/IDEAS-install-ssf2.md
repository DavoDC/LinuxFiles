# SSF2 Install Script Ideas

Ideas and known issues for `Scripts/SSF2/INSTALL_SSF2.sh`.

Directive: `Claude_Workspace/ClaudeOnly/roadmap/directives/linux-files-yt.md`

Reference video (previous): https://www.youtube.com/watch?v=vHMe8zDKM9A

---

## Priority Fixes (before YouTube video)

### Log file ANSI escape sequence issue
- Script outputs color codes to log file (lines with URLs show `[0;33m` and `[0m` literally)
- **Fix:** Detect if stdout is redirected to file, disable color codes when logging or strip them on output

### Scan for other major user-facing issues
- Run through each of the 3 install types manually on Linux Mint
- Document any failures, missing dependencies, or unclear prompts

---

## Test Plan

### 3 Install Types (for video demo)

| Type | Variable | Download | Description |
|------|----------|----------|-------------|
| Native | `native` | `SSF2BetaLinux.*.tar` | Linux native build |
| Wine Install | `wine_inst` | `SSF2BetaSetup.32bit.*.exe` | Windows installer via Wine |
| Wine Port | `wine_port` | `SSF2BetaWindows.32bit.*.portable.zip` | Windows portable via Wine |

Video should demonstrate all 3 types installing successfully.

### Test Steps

1. Linux Mint rig - uninstall any existing SSF2
2. Run INSTALL_SSF2.sh, choose Native - verify installs and launches
3. Uninstall, run again, choose Wine Install - verify
4. Uninstall, run again, choose Wine Portable - verify
5. Record video during a clean run of all 3

---

## Future Ideas (post-video)

- **Windows dry-run improvements** (follow-on from DONE feature in HISTORY-install-ssf2.md):
  - Bashrc advice shows repo path, not a meaningful simulated path - show `/home/user/SSF2` placeholder in dry-run
  - `clear` at script start clears terminal during dev/testing - skip `clear` when DRY_RUN=true
  - `install "wget"` shows a skip banner even though wget is unused in dry-run mode (curl is used) - minor wording fix

- Auto-detect if Wine is installed and skip Wine menu options if not
- Better error messages if download fails (currently silent?)
- `--uninstall` flag to remove installed SSF2
- Support checking for script updates (compare version header against GitHub raw)
