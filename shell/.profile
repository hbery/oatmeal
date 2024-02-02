#!/bin/sh
#
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ]; then
    case ":${PATH}:" in
       *":${HOME}/bin:"*) ;;
       *) export PATH="${HOME}/bin:${PATH}" ;;
    esac
fi

# set PATH so it includes user's private bin if it exists
case ":${PATH}:" in
   *":${HOME}/.local/bin:"*) ;;
   *) export PATH="${HOME}/.local/bin:${PATH}" ;;
esac

case ":${PATH}:" in
   *":${HOME}/.local/sbin:"*) ;;
   *) export PATH="${HOME}/.local/sbin:${PATH}" ;;
esac

if [ -d "/usr/local/go/bin" ]; then
    case ":${PATH}:" in
        *":/usr/local/go/bin:"*) ;;
        *) export PATH="${PATH}:/usr/local/go/bin" ;;
    esac
fi

export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_LOCAL_SHARE_HOME="${XDG_DATA_HOME}"
export XDG_LOCAL_BIN="${HOME}/.local/bin"
if [ "$(uname)" = "Linux" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
elif [ "$(uname)" = "Darwin" ]; then
    export XDG_RUNTIME_DIR="/Users/${USER}/Library/Caches/TemporaryItems"
fi

# source Language specific vars (Perl5,Golang,Rust,Python3,NodeJS)
source "${XDG_CONFIG_HOME}/shell/perl5vars"
source "${XDG_CONFIG_HOME}/shell/govars"
source "${XDG_CONFIG_HOME}/shell/rustvars"
source "${XDG_CONFIG_HOME}/shell/python3vars"
source "${XDG_CONFIG_HOME}/shell/nodevars"
source "${XDG_CONFIG_HOME}/shell/rubyvars"

# if running bash
if [ -n "${BASH_VERSION}" ]; then
    # include .bashrc if it exists
    [ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
fi

if [ "$(uname)" = "Linux" ] && [ -n "${ZSH_VERSION}" ]; then
    # include .zshrc if it exists
    [ -f "${HOME}/.zshrc" ] && source "${HOME}/.zshrc"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
