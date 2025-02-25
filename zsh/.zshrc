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

export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

export EDITOR='vim'
export TERM='xterm-256color'

export PATH=$HOME/.cargo/bin:$HOME/opt/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:/usr/local/go/bin:/opt/bin:$HOME/go/bin:$PATH

[ -f ~/.secrets.zsh ] && source ~/.secrets.zsh
[ -f ~/antigen.zsh ] && source ~/antigen.zsh

export PROMPT_COMMAND="pwd > /tmp/whereami"
precmd() {eval "$PROMPT_COMMAND"}

antigen use oh-my-zsh
antigen bundle git
antigen bundle lukechilds/zsh-nvm
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle unixorn/fzf-zsh-plugin@main
antigen bundle ptavares/zsh-direnv

antigen theme romkatv/powerlevel10k
antigen apply


export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time -p $shell -i -c exit; done
}

eval "$(direnv hook zsh)"

alias ll='exa -al'

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

export NVM_DIR="$HOME/.local/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
 
for d in $HOME/.local/*; do PATH="$PATH:$d/bin"; done

# Add an alias to test a new configuration from ~/config/nvim-kickstart
# alias vim='NVIM_APPNAME="nvim-kickstart" nvim'
alias vim-bak='NVIM_APPNAME="nvim-bak" nvim'
