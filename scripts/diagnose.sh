#!/usr/bin/env bash
set -uo pipefail

# Diagnosi e riparazione dell'allineamento dotfiles su una macchina.
# Raccoglie lo stato prima e dopo, ripara le parti mancanti (stow,
# /opt/nvm, sessione regolith) e pusha il report sul branch
# "diagnostics" per l'analisi da un'altra macchina.

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
report=$repo_dir/diagnostics.txt

stow_packages=(
  alacritty antigen aws bin chrome claude codex git
  ideavim intelephense nvim regolith tmux zsh
)

collect() {
  echo "--- git"
  git -C "$repo_dir" log --oneline -1
  git -C "$repo_dir" status --porcelain

  echo "--- sessione"
  echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-} DESKTOP_SESSION=${DESKTOP_SESSION:-}"

  echo "--- link config"
  ls -ld "$HOME/.config/regolith3" \
    "$HOME/.config/regolith3/Xresources" \
    "$HOME/.config/regolith3/i3/config.d/40_polybar" \
    "$HOME/.config/regolith3/picom.conf" \
    "$HOME/.config/polybar" \
    "$HOME/.config/gtk-3.0" 2>&1

  echo "--- xrdb"
  xrdb -query 2>&1 | grep -i 'wallpaper\|bar\|picom\|border'

  echo "--- processi"
  pgrep -ax polybar
  pgrep -ax picom

  echo "--- log polybar"
  tail -n 15 "$HOME"/.local/state/polybar/*.log 2>&1

  echo "--- nvm"
  ls -ld /opt/nvm 2>&1
  ls /opt/nvm/versions/node 2>&1

  echo "--- avvio zsh interattivo"
  # stdin chiuso: i plugin non devono poter aprire prompt interattivi;
  # KILL perche' una zsh interattiva ignora il TERM di default di timeout
  timeout -s KILL 30 zsh -ic exit </dev/null 2>&1 | head -n 20
}

repair() {
  echo "--- riparazione: stow"
  # una gtk-3.0 reale preesistente bloccherebbe lo stow del package regolith
  if [[ -d $HOME/.config/gtk-3.0 && ! -L $HOME/.config/gtk-3.0 ]]; then
    mv -v "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-3.0.pre-dotfiles"
  fi
  cd "$repo_dir"
  for pkg in "${stow_packages[@]}"; do
    stow -R "$pkg" 2>&1 || echo "CONFLITTO: $pkg"
  done

  echo "--- riparazione: /opt/nvm"
  if [[ ! -s /opt/nvm/nvm.sh ]]; then
    sudo install -d -o "$USER" -g "$(id -gn)" /opt/nvm
    git clone https://github.com/nvm-sh/nvm.git /opt/nvm
    git -C /opt/nvm checkout -q \
      "$(git -C /opt/nvm describe --tags --abbrev=0)"
  else
    echo "nvm: ok"
  fi
  if [[ ! -d /opt/nvm/versions/node ]]; then
    export NVM_DIR=/opt/nvm
    # shellcheck disable=SC1091
    . /opt/nvm/nvm.sh
    nvm install --lts
  fi

  echo "--- riparazione: sessione regolith"
  command -v regolith-look >/dev/null && regolith-look refresh
  command -v i3-msg >/dev/null && i3-msg reload
}

{
  echo "=== $(hostname) - $(date -Is)"
  echo "===== STATO PRIMA"
  collect
  echo "===== RIPARAZIONE"
  repair
  echo "===== STATO DOPO"
  collect
} 2>&1 | tee "$report"

cd "$repo_dir"
current=$(git rev-parse --abbrev-ref HEAD)
git checkout -q -B diagnostics
git add diagnostics.txt
git commit -q -m "Diagnostics from $(hostname)"
git push -f origin diagnostics
git checkout -q "$current"
echo "Report pushato sul branch diagnostics"
