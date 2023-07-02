#!/bin/sh
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "${BASH_VERSION}" ]; then
    # include .bashrc if it exists
    [ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
fi

if [ -n "${ZSH_VERSION}" ]; then
    # include .zshrc if it exists
    [ -f "${HOME}/.zshrc" ] && . "${HOME}/.zshrc"
fi

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
export XDG_LOCAL_SHARE_HOME="${HOME}/.local/share"

# source Language specific vars (Perl5,Golang,Rust,Python3,NodeJS)
source "${XDG_CONFIG_HOME}/shell/perl5vars"
source "${XDG_CONFIG_HOME}/shell/govars"
source "${XDG_CONFIG_HOME}/shell/rustvars"
source "${XDG_CONFIG_HOME}/shell/python3vars"
source "${XDG_CONFIG_HOME}/shell/nodevars"
source "${XDG_CONFIG_HOME}/shell/rubyvars

