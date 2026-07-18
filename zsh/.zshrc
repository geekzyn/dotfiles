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

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# mise
eval "$(/opt/homebrew/bin/mise activate zsh)"

# uv installer shim: adds ~/.local/bin (uv-managed tools and Python) to PATH.
# Guards against duplicate entries, so re-sourcing is safe.
. "$HOME/.local/bin/env"

#######################################################################
#                            Custom alias                             #
#######################################################################
alias ls='gls -ls --hyperlink=auto --color=auto'
