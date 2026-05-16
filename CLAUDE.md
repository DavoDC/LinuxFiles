# LinuxFiles

Linux dotfiles, scripts, and install automation. Companion Google Doc for full Linux setup.

## Repo structure

- `Dotfiles/` - shell config, aliases, etc.
- `Files/` - misc config files
- `Scripts/` - install and utility scripts
  - `Scripts/SSF2/` - user-facing files only (INSTALL_SSF2.sh, etc.)
  - `Scripts/SSF2/Tests/` - developer tests, hidden from end users

## Conventions

- `Scripts/SSF2/` root is for end users - only files they need to download/run go here
- Tests live in `Scripts/SSF2/Tests/` - kept separate so users downloading the script don't see dev scaffolding
- IDEAS and HISTORY for the SSF2 install script: `docs/IDEAS-install-ssf2.md` / `docs/HISTORY-install-ssf2.md`
