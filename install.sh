#!/usr/bin/env bash
# ================================================================
#  dotfiles installer (GNU Stow)
#  Run from the repo root:  ./install.sh
#  Creates symlinks in $HOME for every package in this repo.
# ================================================================
set -euo pipefail

cd "$(dirname "$0")"

# Packages in this repo. Each package mirrors the path relative to $HOME,
# e.g. bspwm/.config/bspwm/bspwmrc  ->  ~/.config/bspwm/bspwmrc
PACKAGES=(bspwm sxhkd polybar alacritty kitty dunst rofi picom bin dmenu mopidy conky zsh vim xinit)

command -v stow >/dev/null 2>&1 || {
  echo "[!] GNU Stow not found."
  echo "    Install it first:  sudo pacman -S stow   (or: sudo apt install stow)"
  echo "    Then re-run this script."
  exit 1
}

echo "[*] Stowing packages: ${PACKAGES[*]}"
for pkg in "${PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    stow -v "$pkg"
  fi
done

echo "[*] Making scripts executable"
chmod +x ~/.config/bspwm/bspwmrc \
        ~/.config/bin/monitor/script.sh \
        ~/.config/bin/temperature/temp.sh \
        ~/.config/bin/touchpad/toggletouchpad.sh \
        ~/.config/bin/randomterminal.sh \
        ~/.dmenu/*.sh \
        ~/.config/polybar/cuts/launch.sh 2>/dev/null || true

# ---- Conky theme (personal / third-party; not bundled in this repo) ----
if [ ! -d "$HOME/.conky/Conky-BSPWM" ]; then
  echo "    [!] Conky-BSPWM theme not found at ~/.conky/Conky-BSPWM."
  echo "        It is a personal third-party theme and is intentionally not part"
  echo "        of this repo. Install it yourself if you want the conky widgets."
fi

echo ""
echo "[+] Done."
echo "    Optional: copy gitignored secrets template:"
echo "      mkdir -p ~/.config/private"
echo "      cp private/secrets.zsh.example ~/.config/private/secrets.zsh"
echo "      $EDITOR ~/.config/private/secrets.zsh"