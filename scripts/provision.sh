#!/usr/bin/env bash
set -euo pipefail

# Installa cio' che i dotfiles presuppongono ma non contengono.
# Idempotente: rieseguibile senza effetti collaterali.
# Richiede l'archivio apt di Regolith (fornisce nordic, arc-icon-theme
# e i pacchetti fonts-nerd-font-*).

repo_dir=$(cd "$(dirname "$0")/.." && pwd)

msg() { printf '==> %s\n' "$*"; }

packages=(
  polybar
  picom
  jq
  vainfo
  git-crypt
  nordic
  arc-icon-theme
  regolith-control-center
  fonts-nerd-font-jetbrainsmono
  fonts-nerd-font-robotomono
)

missing=()
for p in "${packages[@]}"; do
  dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
done

if ((${#missing[@]})); then
  msg "Installo pacchetti mancanti: ${missing[*]}"
  sudo apt-get install -y "${missing[@]}"
else
  msg "Pacchetti apt: ok"
fi

wallpaper="$HOME/wallpapers/aurora.jpg"
if [[ -f "$wallpaper" ]]; then
  msg "Wallpaper: ok"
else
  # Foto di Vincent Guth, licenza Unsplash: non ridistribuibile nel repo
  msg "Scarico il wallpaper in $wallpaper"
  mkdir -p "$HOME/wallpapers"
  curl -fL "https://images.unsplash.com/photo-1483347756197-71ef80e95f73?q=85&fm=jpg&w=3840" \
    -o "$wallpaper"
fi

if head -c 10 "$repo_dir/zsh/.secrets.zsh" | grep -q GITCRYPT; then
  msg "ATTENZIONE: i segreti sono ancora cifrati."
  msg "Esporta la chiave dalla macchina principale: git-crypt export-key <file>"
  msg "Poi qui: cd $repo_dir && git-crypt unlock <file>"
else
  msg "git-crypt: sbloccato"
fi
