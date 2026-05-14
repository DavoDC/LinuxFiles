# LinuxFiles General Ideas

General improvement ideas for the LinuxFiles repo - dotfiles, GEN_SETUP.sh, and other scripts.

---

## GEN_SETUP.sh Improvements

### Fix link issue - dotfile setup not wired in
- `CONFIGURE_DOTFILES.sh` handles symlinks but GEN_SETUP.sh never calls it
- Users have to discover and run the dotfile script manually
- Fix: add a prompt at the end of GEN_SETUP.sh offering to configure dotfiles

### Fix duplicate installSnap definition
- `installSnap` is defined twice in the helper functions section
- The comment above the second definition incorrectly says "installDeb" - copy-paste error
- Second definition is identical to the first so no behavioural difference, but it's confusing
- Fix: delete the duplicate block

### Add run logging
- Tee output to a timestamped log file: `exec > >(tee -a "$LOG_FILE") 2>&1`
- Keeps terminal interface identical, user can share log for debugging

### Known dead URL risks
- `libpangox`: `http://ftp.us.debian.org/debian/pool/main/p/pangox-compat/` - old Debian package, may 404
- `Consolas font`: `storage.googleapis.com/google-code-archive-downloads` - Google Code Archive, may go offline
- Check before recommending to users

### Minor issues (low priority)
- `gnome-text-editor` set as git editor but Dracula theme installed for `gedit` - inconsistency on Ubuntu 22+
- `rfkill block bluetooth` in `/etc/rc.local` is legacy startup method - may not work on newer Ubuntu/Mint
- Grub Customizer commented out "DISABLED AS NO LONGER AVAILABLE FOR UBUNTU 22" - remove entirely to reduce confusion

---

## Future Ideas

- `--dry-run` flag to show what would be installed without installing
- Per-section timing (how long did each section take?)
