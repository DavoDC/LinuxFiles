# Install Script Ideas

Ideas and known issues for `Scripts/GEN_SETUP.sh` and `Dotfiles/CONFIGURE_DOTFILES.sh`.

Directive: `Claude_Workspace/ClaudeOnly/roadmap/directives/linux-files-yt.md`

---

## Priority Fixes (before YouTube video)

### Link issue - dotfile configuration not wired into GEN_SETUP.sh
- `CONFIGURE_DOTFILES.sh` handles symlinks but GEN_SETUP.sh never calls it
- Users have to discover and run the dotfile script manually
- Fix: add a prompt at the end of GEN_SETUP.sh offering to configure dotfiles

### Remove Wine section
- Wine/wine32/winbind + `--add-architecture i386` block is heavy and uncommon
- Most users don't need it
- Remove the entire SSF2 Wine block

### Add run logging
- Every run should tee output to a timestamped log file at `$HOME/gen-setup-YYYYMMDD-HHMMSS.log`
- Keeps terminal interface identical, but user can share the log for debugging
- Implementation: `exec > >(tee -a "$LOG_FILE") 2>&1` near top of script

### Fix duplicate installSnap definition
- `installSnap` is defined twice in the helper functions section
- The comment above the second definition incorrectly says "installDeb" - copy-paste error
- The second definition is identical to the first so no behavioural difference, but it's confusing
- Fix: delete the duplicate `installSnap` block (lines with the incorrect "installDeb" comment)

---

## Known Dead URL Risks (major - will break for new users)

- **libpangox**: downloaded from `http://ftp.us.debian.org/debian/pool/main/p/pangox-compat/` - old Debian package, may 404
- **Consolas font**: downloaded from `storage.googleapis.com/google-code-archive-downloads` - Google Code Archive, may go offline
- **Fallout GRUB theme**: downloaded from shiftkey's GitHub - likely stable but worth noting

Action: check URLs are live before recording video. Find fallbacks if needed.

---

## Minor Issues (post-video, if at all)

- `gnome-text-editor` set as git editor, but Dracula theme installed for `gedit` - inconsistency (Ubuntu 22+ uses gnome-text-editor, not gedit)
- `rfkill block bluetooth` in `/etc/rc.local` is legacy startup method - may not work on newer Ubuntu/Mint
- `isNotInstalled` uses `dpkg-query` - Debian/Ubuntu only, contradicts the comment "for all distros"
- GRUB customizer is commented out "DISABLED AS NO LONGER AVAILABLE FOR UBUNTU 22" - should be removed entirely to avoid confusion

---

## Future Ideas (low priority, post-video)

- Add `--dry-run` flag to print what would be installed without installing
- Add per-section timing (how long did package installs take?)
- Interactive mode vs. silent mode (currently always interactive via sudo prompts)
- Test on Debian, Pop!_OS, Zorin to verify compatibility
