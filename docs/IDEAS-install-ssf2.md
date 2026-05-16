# SSF2 Install Script Ideas

Ideas and known issues for `Scripts/SSF2/INSTALL_SSF2.sh`.

Directive: `Claude_Workspace/ClaudeOnly/roadmap/directives/linux-files-yt.md`

Reference video (previous): https://www.youtube.com/watch?v=vHMe8zDKM9A

---

## Priority Fixes (before YouTube video)

### Scan for other major user-facing issues
- Run through each of the 3 install types manually on Linux Mint
- Document any failures, missing dependencies, or unclear prompts

---

## 3 Install Types (for video demo)

| Type | Variable | Download | Description |
|------|----------|----------|-------------|
| Native | `native` | `SSF2BetaLinux.*.tar` | Linux native build |
| Wine Install | `wine_inst` | `SSF2BetaSetup.32bit.*.exe` | Windows installer via Wine |
| Wine Port | `wine_port` | `SSF2BetaWindows.32bit.*.portable.zip` | Windows portable via Wine |

Video should demonstrate all 3 types installing successfully.

---

## Test Plan

1. Linux Mint rig - uninstall any existing SSF2
2. Run INSTALL_SSF2.sh, choose Native - verify installs and launches
3. Uninstall, run again, choose Wine Install - verify
4. Uninstall, run again, choose Wine Portable - verify
5. Record video during a clean run of all 3

---

## Future Ideas (post-video)

- **Windows dry-run mode** - if MSYS/Cygwin detected (currently exits immediately), enter a dry-run mode instead of aborting. Simulates the full script flow: shows menus, extracts and prints download URLs, logs output - but skips any actual installs/downloads. **Must display a prominent banner at the top and before every skipped step so the user cannot mistake it for a real run.** `DRY_RUN=true` flag could also trigger it explicitly on any platform for dev testing. Note: considered supporting actual Windows installs via Git Bash (Portable + Installer versions would work natively - no Wine needed on Windows), but decided against it - this repo is Linux-only and Windows scripts belong in WindowsFiles.

- Auto-detect if Wine is installed and skip Wine menu options if not
- Better error messages if download fails (currently silent?)
- `--uninstall` flag to remove installed SSF2
- Support checking for script updates (compare version header against GitHub raw)
