# SSF2 Install Script Ideas

Ideas and known issues for `Scripts/SSF2/INSTALL_SSF2.sh`.

Directive: `Claude_Workspace/ClaudeOnly/roadmap/directives/linux-files-yt.md`

Reference video (previous): https://www.youtube.com/watch?v=vHMe8zDKM9A

---

## Priority Fixes (before YouTube video)

### Add run logging
- Every run should tee output to a timestamped log file at `./ssf2-install-YYYYMMDD-HHMMSS.log`
- Keeps terminal interface identical, but user can share the log for debugging
- Implementation: `exec > >(tee -a "$LOG_FILE") 2>&1` near top of script

### Scan for link / URL issues (first step)
- The script fetches the SSF2 download page (`offURL`) and parses download links
- Check: does the official download URL (`www.supersmashflash.com/play/ssf2/downloads/`) still work?
- Check: are the regex patterns (`patt_native`, `patt_wine_inst`, `patt_wine_port`) still matching current filenames?
- Check: CDN URL `cdn.supersmashflash.com/ssf2/downloads` - still live?
- These are the most likely breakage points for new users

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

- Auto-detect if Wine is installed and skip Wine menu options if not
- Better error messages if download fails (currently silent?)
- `--uninstall` flag to remove installed SSF2
- Support checking for script updates (compare version header against GitHub raw)
