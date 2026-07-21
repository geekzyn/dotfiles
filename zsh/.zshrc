#######################################################################
#                          General settings                           #
#######################################################################
# Enable autocompletion
autoload -Uz compinit && compinit

# use vim in command-line
set -o vi

# ignore hashtag
setopt INTERACTIVE_COMMENTS

# zsh syntax highlighting and autosuggestions
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

#######################################################################
#                        Environment variables                        #
#######################################################################
# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY 
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

#######################################################################
#                           Tools settings                            #
#######################################################################
# Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# aichat
export AICHAT_CONFIG_DIR=~/.config/aichat

# fzf key bindings and fuzzy completion
source <(fzf --zsh)

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# carapace-bin
autoload -U compinit && compinit
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# intelli-shell: shell integration + completions
# Search: ctrl+space | Bookmark: ctrl+b | Variables: ctrl+l | Fix: ctrl+x
eval "$(intelli-shell init zsh)"

# mise
eval "$(/opt/homebrew/bin/mise activate zsh)"

# uv installer shim: adds ~/.local/bin (uv-managed tools and Python) to PATH.
# Guards against duplicate entries, so re-sourcing is safe.
. "$HOME/.local/bin/env"

#######################################################################
#                            Custom alias                             #
#######################################################################
alias ls='gls -ls --hyperlink=auto --color=auto'

# llm: pass a natural-language request to aichat execute mode
# e.g. llm list my files
llm() {
  aichat -e "$*"
}

