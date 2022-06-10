# Env variables
export TERM=xterm-256color
export HISTCONTROL=ignoredups:erasedups
export EDITOR=nvim
export PAGER=less
export BROWSER=brave-browser
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
export TMUX_PLUGIN_MANAGER_PATH=$HOME/.config/tmux/plugins

export PF_INFO="ascii title os host kernel shell uptime pkgs editor memory"
# export GOPRIVATE="github.com/$GITUSER/*,gitlab.com/$GITUSER/*"

export GOPATH="${HOME}/.local/share/go"
export GOBIN="${HOME}/.local/bin"
export GOPROXY=direct
export CGO_ENABLED=0

# XXX: temporary fix for sddm (plasma version 5.18)
[ -e $HOME/.profile ] && source $HOME/.profile
