#!/bin/sh
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# shellcheck disable=SC1091,SC3046
#
# umask 022

_profile_uname="$(uname)"

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

# most Go installations put binaries in /usr/local/go/bin, unless
# e.g. installed with _system/install-go-systemwide.sh
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
export XDG_LOCAL_SBIN="${HOME}/.local/sbin"
if [ "${_profile_uname}" = "Linux" ]; then
    # shellcheck disable=SC2155
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"
elif [ "${_profile_uname}" = "Darwin" ]; then
    export XDG_RUNTIME_DIR="/Users/${USER}/Library/Caches/TemporaryItems"
fi

# source Language specific vars (Perl5,Golang,Rust,Python3,NodeJS)
source "${XDG_CONFIG_HOME}/shell/perl5vars"
source "${XDG_CONFIG_HOME}/shell/govars"
source "${XDG_CONFIG_HOME}/shell/rustvars"
source "${XDG_CONFIG_HOME}/shell/python3vars"
source "${XDG_CONFIG_HOME}/shell/nodevars"
source "${XDG_CONFIG_HOME}/shell/rubyvars"

if [ -n "${BASH_VERSION}" ]; then
    [ -f "${HOME}/.bashrc" ] && source "${HOME}/.bashrc"
fi

if [ "${_profile_uname}" = "Linux" ] && [ -n "${ZSH_VERSION}" ]; then
    [ -f "${HOME}/.zshrc" ] && source "${HOME}/.zshrc"
fi

[ -d "/home/linuxbrew" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
