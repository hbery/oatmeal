# ~~~
#                __
#    ____  _____/ /_  __________
#   /_  / / ___/ __ \/ ___/ ___/
#  _ / /_(__  ) / / / /  / /__
# (_)___/____/_/ /_/_/   \___/
#
# by hbery
# ~~~

# . ~/.cargo/env

# Load colors
autoload -U colors && colors

# PS1 setup
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Zsh options
setopt autocd
stty stop undef
# setopt interactive_comments

# bindings
bindkey "^[." insert-last-word

# History settings
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# Include hidden files.
_comp_options+=(globdots)

# Syntax highlightning
source ${HOME}/.local/share/zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh 2>/dev/null

# Invoke aliases
[ -f ~/.config/shell/aliasrc ] && source ~/.config/shell/aliasrc

# Use starship prompt
eval "$(starship init zsh)"
