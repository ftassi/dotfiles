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

export PATH=$HOME/.cargo/bin:$HOME/bin:/usr/local/bin:/usr/local/go/bin:$HOME/go/bin:$PATH

[ -f ~/.secrets.zsh ] && source ~/.secrets.zsh
[ -f ~/antigen.zsh ] && source ~/antigen.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PROMPT_COMMAND="pwd > /tmp/whereami"
precmd() {eval "$PROMPT_COMMAND"}

antigen use oh-my-zsh
antigen bundle git
antigen bundle lukechilds/zsh-nvm
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle unixorn/fzf-zsh-plugin@main

antigen theme agnoster/agnoster-zsh-theme
antigen apply

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time -p $shell -i -c exit; done
}
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

alias ll='ls -al'

export PATH=~/.config/composer/vendor/bin:$PATH
