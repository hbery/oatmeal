#!/bin/bash
# ~~~
#       __               __
#      / /_  ____ ______/ /_  __________
#     / __ \/ __ `/ ___/ __ \/ ___/ ___/
#  _ / /_/ / /_/ (__  ) / / / /  / /__
# (_)_.___/\__,_/____/_/ /_/_/   \___/
#
# by hbery
# ~~~

if [ -n "${TMUX+1}" ]; then
    export TERM=tmux-256color
else
    export TERM=xterm-256color
fi
export HISTCONTROL=ignoredups:erasedups
export EDITOR=vim
export PAGER=less
export BROWSER=brave-browser
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER="less -s -M +Gg"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export TMUX_PLUGIN_MANAGER_PATH=$HOME/.config/tmux/plugins

source ~/.config/shell/less_termcap

# `pfetch` vars
export PF_INFO="ascii title os host kernel shell uptime pkgs editor memory"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Shell options
bind -m emacs
shopt -s histappend
shopt -s checkwinsize

# History settings
HISTSIZE=10000000
HISTFILESIZE=10000000
HISTFILE=~/.cache/bash/history

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# PS1 setup
_nonzero_return () {
    RETVAL=$?
    [ $RETVAL -ne 0 ] && echo "$RETVAL "
}

export PS1="\[\e[35m\]\`_nonzero_return\`\[\e[m\]\[\e[31m\][\[\e[m\]\[\e[34m\]\A\[\e[m\] \[\e[33m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[36m\]\h\[\e[m\] \[\e[35m\]\w\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "

# Invoke aliases
[ -f ~/.config/shell/aliasrc ] && source ~/.config/shell/aliasrc

# Bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Bash insulter
if [ -f /etc/bash.command-not-found ]; then
    source /etc/bash.command-not-found
fi

# Starship prompt setup
eval "$(starship init bash)"
