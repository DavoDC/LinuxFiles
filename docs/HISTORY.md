# LinuxFiles - Completed Ideas & Tasks

## Claude Code launcher alias (claude_container)
**Completed:** 2026-07-21

Added a `claude_container` alias to `Dotfiles/Actual/.bashrc` so the Claude Code launcher (same
one the Desktop shortcut runs) can be started from any Git Bash terminal by typing
`claude_container`, instead of only via the desktop shortcut.

**Design: local-override pattern.** The real launcher script lives outside this repo in a
private local project whose path is machine-specific, and `LinuxFiles`/`Dotfiles` is a public
repo, so the tracked `.bashrc` never hardcodes that path. Instead:
- `Dotfiles/Actual/.bashrc` defines the `claude_container` alias, which runs
  `$CLAUDE_CONTAINER_SCRIPT` if set and executable, else prints a hint to configure it in
  `~/.bashrc_local`.
- `Dotfiles/Actual/.bashrc` also sources `~/.bashrc_local` if present - a reusable
  local-override mechanism, not a one-off hack.
- The untracked `~/.bashrc_local` (outside any git repo, never committed) sets
  `CLAUDE_CONTAINER_SCRIPT` to the real launcher path on that machine.

**Non-interactive redeploy.** `CONFIGURE_DOTFILES.sh` was fully interactive (`read -p` prompts
for the configure/unconfigure menu and the `ask_continue` y/n check), which meant it always
needed a human at the keyboard to redeploy `.bashrc` after an edit. Added `--configure` /
`--unconfigure` flags (skip the 1/2 menu) and `--yes`/`-y` (auto-answer the confirmation
prompt); the interactive menu remains the default when no flags are given. Verified with
`./CONFIGURE_DOTFILES.sh --configure --yes`, which redeployed `Actual/.bashrc` to
`~/.bash_profile` with zero prompts, then confirmed the alias resolves correctly in a real
login+interactive shell (`bash -i` sourcing `~/.bash_profile`).

**Naming note:** the alias was originally named `claude_launch`, briefly renamed to
`claude_container` to match a since-removed Docker DevContainer launcher naming scheme in the
private workspace, then kept as `claude_container` after that DevContainer mode was retired -
see the private workspace changelog for that removal (not tracked in this public repo).
