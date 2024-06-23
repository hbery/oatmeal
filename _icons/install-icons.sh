#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2022
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Simple bootstrapping script to get and engage install-scripts for icons
# ~~~

_iconInstallDirectory="${ICON_INSTALLDIR:-"${HOME}/.local/share/icons"}"
_iconTmpDirectory="${ICON_TMPDIR:-"/tmp"}"

_installTelaCircleIconsFn () {
    # get Tela-circle-icon-theme and install locally
    git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/Tela-circle
    chmod u+x /tmp/Tela-circle/install.sh
    /tmp/Tela-circle/install.sh -a -d "${_iconInstallDirectory}"
}

_installTelaIconsFn () {
    # get Tela-icon-theme and install locally
    git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela
    chmod u+x /tmp/Tela/install.sh
    /tmp/Tela/install.sh -a -d "${_iconInstallDirectory}"
}

_installPapirusIconsFn () {
    # get papirus-icon-theme and install locally
    wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="${_iconInstallDirectory}" sh
}

_installQogirIconsFn () {
    # get Qogir-icon-theme and install locally
    git clone https://github.com/vinceliuice/Qogir-icon-theme.git /tmp/Qogir
    chmod u+x /tmp/Qogir/install.sh
    /tmp/Qogir/install.sh -d "${_iconInstallDirectory}"
}

_mainFn () {
    [ ! -d "${_iconInstallDirectory}" ] \
        && mkdir "${_iconInstallDirectory}"

    _installTelaCircleIconsFn
    _installTelaIconsFn
    _installPapirusIconsFn
    _installQogirIconsFn
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
