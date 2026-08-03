# bspwm-dotfiles

Personal dotfiles for **Arch / CachyOS** with **bspwm**, managed with **GNU Stow**.

```
~/dotfiles/
│
├── bspwm/      -> ~/.config/bspwm/bspwmrc
├── sxhkd/      -> ~/.config/sxhkd/sxhkdrc
├── polybar/    -> ~/.config/polybar/cuts   (active "cuts" theme)
├── alacritty/  -> ~/.config/alacritty
├── kitty/      -> ~/.config/kitty
├── dunst/      -> ~/.config/dunst/dunstrc
├── rofi/       -> ~/.config/rofi
├── picom/      -> ~/.config/picom/picom.conf
├── bin/        -> ~/.config/bin            (personal scripts)
├── dmenu/      -> ~/.dmenu                 (dmenu scripts)
├── mopidy/     -> ~/.config/mopidy/mopidy.conf
├── conky/      -> ~/.conky/conky-startup.sh
├── zsh/        -> ~/.zshrc, ~/.p10k.zsh
├── vim/        -> ~/.vimrc
├── xinit/      -> ~/.xinitrc, ~/.xprofile
│
├── private/secrets.zsh.example   (template; the real file is gitignored)
├── install.sh
└── .gitignore
```

## Requirements

- Arch Linux (or Arch-based), `bspwm` + `sxhkd`
- `polybar-msg`, `picom`, `dunst`, `rofi`
- A terminal (kitty or alacritty)
- Zsh with powerlevel10k (optional), vim
- **GNU Stow**

## How it works

Each top-level folder is a **Stow package**. It holds files at the same relative
path as they appear in your `$HOME`. Running `stow <package>` creates symlinks:

```
dotfiles/sxhkd/.config/sxhkd/sxhkdrc   →   ~/.config/sxhkd/sxhkdrc
dotfiles/zsh/.zshrc                     →   ~/.zshrc
```

Edit the files in this repo (they *are* your live config via symlinks), then
commit.

## Install

```bash
# 1. Tools
sudo pacman -S stow bspwm sxhkd polybar picom dunst rofi kitty alacritty

# 2. Get the repo
git clone https://github.com/mrdodgerx/bspwm-dotfiles.git ~/dotfiles
cd ~/dotfiles

# 3. Link everything into $HOME
./install.sh
```

### Secrets (all gitignored)

Credentials are **never** committed. Keep them out of git automatically:

- Anything in `~/.config/private/`
- `polybar/.../cuts/.password`
- Spotify `credentials` files
- SSH keys / certs / tokens (see `.gitignore`)

On a new machine, create `~/.config/private/secrets.zsh` (`.zshrc` sources it):

```bash
cp private/secrets.zsh.example ~/.config/private/secrets.zsh
$EDITOR ~/.config/private/secrets.zsh
```

If you ever accidentally commit a secret, purge it from history with
`git filter-repo` and rotate the value.

## Not in this repo (by design)

- `bin/main/*` personal bootstrap scripts (kept locally, not shared).
- Third-party vendored themes (`polybar-themes`, `conky-grapes`, `polybarazan`) —
  reference the upstream sources instead.
- The **`Conky-BSPWM`** conky theme is a separate personal clone and is **not**
  bundled. `conky/.conky/conky-startup.sh` expects it at `~/.conky/Conky-BSPWM/`;
  install it yourself if you use conky.
- `dmenu-edit-configs.sh` lists config files only when they exist on your machine.

## Disclaimer

These are personal configs; paths/fonts/shortcuts are tuned to one machine.
Adjust to taste.