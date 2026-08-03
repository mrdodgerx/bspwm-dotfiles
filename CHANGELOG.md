# Changelog

## [2026-08-03] — Initial public release

- Dotfiles rebuilt as a **GNU Stow** repo: every top-level package mirrors `$HOME`
  and `./install.sh` links everything with one command.
- Packaged configs: `bspwm`, `sxhkd`, `polybar` (cuts), `alacritty`, `kitty`,
  `dunst`, `rofi`, `picom`, `bin` scripts, `dmenu`, `mopidy`, `conky` (launcher),
  `zsh`, `vim`, `xinit`.
- Secrets are kept out of git: `.gitignore` covers credentials, keys, backups
  (`.bak`/`.ori`), runtime state and vendored third-party sub-repos; local tokens
  are sourced from a gitignored `~/.config/private/secrets.zsh`.
- Hardcoded user paths replaced with `$HOME` for portability.
- `dmenu-edit-configs.sh` lists configs only when they exist; polybar entry points
  at the active `cuts/config.ini`.
- Fixed `bin/others/watch-gtk-theme.sh` to call `others/sync-gtk-theme.sh`.