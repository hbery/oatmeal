#!/bin/zsh
# Env variables
if [ -n "${TMUX+1}" ]; then
    export TERM=tmux-256color
else
    export TERM=xterm-256color
fi
export HISTCONTROL=ignoredups:erasedups
export EDITOR=nvim
export PAGER=less
export BROWSER=brave-browser
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANPAGER="less -R -s -M +Gg"
export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
export TMUX_PLUGIN_MANAGER_PATH="${XDG_DATA_HOME:-"${HOME}/.local/share"}/tmux/plugins"

export PF_INFO="ascii title os host kernel shell uptime pkgs editor memory"

source ~/.config/shell/less_termcap

# XXX: temporary fix for sddm (plasma version 5.18)
[ -e $HOME/.profile ] && source $HOME/.profile
