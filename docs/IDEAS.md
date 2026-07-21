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

---

## Claude Code launcher alias (claude_launch)

### Goal
Run the Claude Code launcher (the same thing the Desktop shortcut runs) from any Git Bash
terminal by typing `claude_launch`, instead of only via the desktop shortcut.

### Constraint that shapes the design
The real launcher script lives outside this repo, in a private local project whose path is
machine-specific. `LinuxFiles`/`Dotfiles` is a **public** repo, so no local/private paths
should ever be hardcoded into the tracked `.bashrc`.

### Design: local-override pattern
- Tracked `Dotfiles/Actual/.bashrc` gets:
  1. A `claude_launch` alias that runs `$CLAUDE_LAUNCH_SCRIPT` if set and executable, else
     prints a one-line hint to configure it in `~/.bashrc_local`.
  2. A generic `[ -f "$HOME/.bashrc_local" ] && source "$HOME/.bashrc_local"` line - a
     reusable local-override mechanism, not a one-off hack.
- Untracked `~/.bashrc_local` (lives outside any git repo, never committed) sets
  `CLAUDE_LAUNCH_SCRIPT` to the real launcher path on that machine.
- Deploy path: `CONFIGURE_DOTFILES.sh` (option 1, Windows) copies `Actual/.bashrc` to
  `~/.bash_profile` as before - unaffected by the local-override file, since that file is
  never touched by the configure script and persists across reconfigures.

### Step 1 (done) - alias only
Added `claude_launch` + the `.bashrc_local` sourcing hook to `Actual/.bashrc`, and created
a local `~/.bashrc_local` pointing `CLAUDE_LAUNCH_SCRIPT` at the real launcher. Committed to
Dotfiles. Live deploy (copying to `~/.bash_profile`) is a manual `CONFIGURE_DOTFILES.sh`
run - not automated in this pass.

### Step 2 (future) - CLI args for CONFIGURE_DOTFILES.sh
Currently the script is fully interactive (`read -p` prompts for configure/unconfigure and a
y/n continue check). Add non-interactive flags so it can be run/re-run without prompts, e.g.:
- `./CONFIGURE_DOTFILES.sh --configure` / `--unconfigure` (skips the 1/2 menu)
- `--yes` / `-y` (auto-answers the `ask_continue` y/n prompt)
- Keep the interactive menu as the default when no flags are given (backward compatible)
This unlocks silent/repeatable re-configuration (e.g. from a script or Claude) instead of
requiring a human to sit through the prompts every time.
