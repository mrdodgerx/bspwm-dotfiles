# ==========================================
# POWERLEVEL10K INSTANT PROMPT (TOP)
# ==========================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==========================================
# ENVIRONMENT VARIABLES
# ==========================================
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"
export CHROME_EXECUTABLE="/usr/bin/google-chrome-stable"
export XDG_CURRENT_DESKTOP="bspwm"
# Load local secrets (gitignored). Real tokens live in ~/.config/private/secrets.zsh
[[ -f "$HOME/.config/private/secrets.zsh" ]] && source "$HOME/.config/private/secrets.zsh"
# Load local SSH host shortcuts (gitignored, LAN-only). See ~/.config/private/ssh-aliases.zsh
[[ -f "$HOME/.config/private/ssh-aliases.zsh" ]] && source "$HOME/.config/private/ssh-aliases.zsh"
export OPENCODE_SERVER_PASSWORD="${OPENCODE_SERVER_PASSWORD:-}"
export OPENCODE_SERVER_URL="http://127.0.0.1:4096"

# Clean PATH (deduplicated)
typeset -U path PATH
path=(
  $HOME/.opencode/bin
  $HOME/.local/bin
  $ANDROID_HOME/platform-tools
  $ANDROID_HOME/emulator
  $ANDROID_HOME/cmdline-tools/latest/bin
  $ANDROID_HOME/tools/bin
  $path
)

# ==========================================
# OH-MY-ZSH
# ==========================================
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)

source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ==========================================
# SHELL OPTIONS
# ==========================================
setopt auto_cd
setopt correct
setopt hist_ignore_dups
setopt share_history

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload -Uz compinit
compinit -C

# ==========================================
# PLUGINS (LOAD LAST)
# ==========================================
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# ==========================================
# CUSTOM FUNCTIONS
# ==========================================

recon() {
  [[ -z "$1" ]] && echo "Usage: recon <domain>" && return 1
  subfinder -d "$1" -all -silent |
  sort -u |
  grep -E '^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' |
  grep -vE '^_|_domainkey|_dmarc|_acme' |
  dnsx -a -aaaa -silent |
  httpx-toolkit -silent
}

reconip() {
  [[ -z "$1" ]] && echo "Usage: reconip <domain>" && return 1
  subfinder -d "$1" -all -silent |
  sort -u |
  grep -E '^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' |
  grep -vE '^_|_domainkey|_dmarc|_acme' |
  dnsx -a -aaaa -silent -json |
  jq -r '
    .host as $h |
    ( .a + .aaaa | unique ) as $ips |
    "https://\($h)\t[\($ips | join(", "))]"
  '
}

ipinfo() {
  [[ -z "$1" ]] && echo "Usage: ipinfo <ip|domain>" && return 1

  target="$1"

  # If input is not an IP, resolve it
  if ! [[ "$target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    target=$(dig +short "$target" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | head -n1)
  fi

  [[ -z "$target" ]] && echo "Could not resolve domain to IP." && return 1

  curl -s -H "Authorization: Bearer ${IPINFO_TOKEN:-}" "https://ipinfo.io/$target" | jq
}

# Add this to ~/.bashrc or ~/.zshrc
exzip() {
  local filename=$(basename "$1" .zip)
  unzip "$1" -d "$filename"
}

# Mount Windows partition with optional custom mount point
mountwin() {
    local mountpoint="${1:-$HOME/temp}"
    mkdir -p "$mountpoint"
    
    echo "Mounting Windows partition to $mountpoint..."
    sudo mount -t ntfs-3g -o rw,uid=$(id -u),gid=$(id -g) /dev/nvme0n1p4 "$mountpoint" || \
    sudo mount -t ntfs-3g -o remove_hiberfile,uid=$(id -u),gid=$(id -g) /dev/nvme0n1p4 "$mountpoint"
}

umountwin() {
    sudo umount "${1:-$HOME/temp}"
}

# ==========================================
# ALIASES (CLEAN + MERGED)
# ==========================================

### Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

### Package Management (Arch)
alias pacman='pacman --noconfirm'
alias yay='yay --noconfirm'
alias update='sudo pacman -Syu'
alias pacsyu='sudo pacman -Syyu'
alias yaysyu='yay -Syu --noconfirm'
alias yaysua='yay -Sua --noconfirm'
alias unlock='sudo rm /var/lib/pacman/db.lck'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq 2>/dev/null)'
alias cleanup2='pacman -Qdtq | sudo pacman -Rns -'
alias removeallcached='sudo pacman -Scc'
alias removepackageacached='sudo pacman -Sc'
alias fixpacman='sudo rm /var/lib/pacman/db.lck'
alias apt='man pacman'
alias apt-get='man pacman'

### Mirrors
alias mirror='sudo cachyos-rate-mirrors'
alias mirrord='sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors='sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'
alias mirrora='sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'

### File Listing (eza)
alias ls='eza -al --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'
alias l.='eza -a | grep "^\."'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

### Grep Colors
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

### Safe File Operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

### Disk & Process
alias df='df -h'
alias free='free -m'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias hw='hwinfo --short'

### Git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias status='git status'
alias tag='git tag'
alias newtag='git tag -a'
alias gitpkg='pacman -Q | grep -i "\\-git" | wc -l'

### Journal
alias jctl='journalctl -p 3 -xb'

### Boot & System
alias grubup='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias ssn='sudo shutdown now'
alias sr='sudo reboot'
alias servicerun='systemctl list-units --type=service'

### GPG
alias gpg-check='gpg2 --keyserver-options auto-key-retrieve --verify'
alias gpg-retrieve='gpg2 --keyserver-options auto-key-retrieve --receive-keys'

### Archive
alias tarnow='tar -acf'
alias untar='tar -zxvf'

### Network
alias tb='nc termbin.com 9999'
alias wget='wget -c'

### Misc
alias please='sudo'
alias cat='bat'
alias ms='ncmpcpp --host=localhost --port=6600'
alias lsusb-new='diff <(lsusb) <(sleep 1 && lsusb)'
alias fa='fastanime anilist'
alias fas='fastanime --media-api anilist search -t'

### Fix Scripts
alias fix-polybar='$HOME/.config/bin/others/fix-polybar.sh'
alias fpb='$HOME/.config/bin/others/fix-polybar.sh'
alias fix-monitor='$HOME/.config/bin/monitor/script.sh'
alias fix-machine-id='sudo $HOME/.config/bin/others/fix-machine-id.sh'

# ==========================================
# OPTIONAL RANDOM TERMINAL
# ==========================================
[[ -x ~/.config/bin/randomterminal.sh ]] && ~/.config/bin/randomterminal.sh

# OpenClaw Completion
source "$HOME/.openclaw/completions/openclaw.zsh"

export TERM=xterm
export TERM=xterm-256color

export PATH="$HOME/.npm-global/bin:$PATH"

# Fix Kerberos for RDP connections
export KRB5_CONFIG=$HOME/.krb5_minimal.conf
