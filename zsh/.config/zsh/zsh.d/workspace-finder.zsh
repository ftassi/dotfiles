workspace-finder() {
  local dir
  dir=$(find ~/workspace -type d 2>/dev/null | fzf --height 40% --reverse --prompt "workspace> ")
  if [[ -n "$dir" ]]; then
    LBUFFER+="$dir"
  fi
  zle redisplay
}
zle -N workspace-finder
bindkey '^P' workspace-finder
