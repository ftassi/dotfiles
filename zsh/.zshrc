# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# the detailed meaning of the below three variable can be found in `man zshparam`.
export HISTFILE=~/.local/share/zsh/histfile
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt HIST_IGNORE_SPACE  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time
setopt PROMPT_SUBST

export FZF_PATH="${HOME}/.fzf"

export NVM_DIR="/opt/nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

# Add default node to PATH immediately (no nvm overhead) so tools like
# copilot find node without waiting for lazy load.
# NB: prende la versione più alta installata, non nvm alias default.
_nvm_default_node=("$NVM_DIR/versions/node/"v*(N/nOn))
(( ${#_nvm_default_node} )) && export PATH="${_nvm_default_node[1]}/bin:$PATH"
unset _nvm_default_node

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export EDITOR='vim'
export TERM='xterm-256color'

export PATH=$HOME/.cargo/bin:$HOME/opt/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/go/bin:/opt/bin:$HOME/go/bin:$PATH

[ -f ~/.secrets.zsh ] && source ~/.secrets.zsh
[ -f ~/antigen.zsh ] && source ~/antigen.zsh

export PROMPT_COMMAND="pwd > /tmp/whereami-$USER"
precmd() {eval "$PROMPT_COMMAND"}
[[ -f /tmp/whereami-$USER ]] && cd "$(< /tmp/whereami-$USER)"

antigen use oh-my-zsh
antigen bundle git
antigen bundle lukechilds/zsh-nvm
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle unixorn/fzf-zsh-plugin@main


antigen theme romkatv/powerlevel10k
antigen apply


export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time -p $shell -i -c exit; done
}

eval "$(direnv hook zsh)"


export PATH=~/.config/composer/vendor/bin:$PATH

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/.p10k.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/zsh/.p10k.zsh
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/op/plugins.sh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/op/plugins.sh
[ -f ~/.fzf/.fzf.zsh ] && source ~/.fzf/.fzf.zsh

# Source every zsh.d file
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/zsh.d"
if [[ -d $config_dir && -n $(ls $config_dir/*.zsh 2>/dev/null) ]]; then
  for config_file ($config_dir/*.zsh); do
    source $config_file
  done
fi

 
for d in $HOME/.local/*; do PATH="$PATH:$d/bin"; done

