#!/bin/sh
# vim: ft=bash : ts=2 : sw=2 :
# ~~~
# Date: 2022
# Author: Adam Twardosz (github.com/hbery)
# Purpose: simple bootstrapping script to get
#   and engage install-scripts for icons
# ~~~

_iconInstallDirectory="${HOME}/.local/share/icons"

### BEGIN: FUNCTION_SECTION {
## BEGIN _installTelaCircleIconsFn {
_installTelaCircleIconsFn () {
  # get Tela-circle-icon-theme and install locally
  git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/Tela-circle
  chmod u+x /tmp/Tela-circle/install.sh
  /tmp/Tela-circle/install.sh -a -d "${_iconInstallDirectory}"
}
## . END _installTelaCircleIconsFn }

## BEGIN _installTelaIconsFn {
_installTelaIconsFn () {
  # get Tela-icon-theme and install locally
  git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela
  chmod u+x /tmp/Tela/install.sh
  /tmp/Tela/install.sh -a -d "${_iconInstallDirectory}"
}
## . END _installTelaIconsFn }

## BEGIN _installPapirusIconsFn {
_installPapirusIconsFn () {
  # get papirus-icon-theme and install locally
  wget -qO- https://git.io/papirus-icon-theme-install | DESTDIR="${_iconInstallDirectory}" sh
}
## . END _installPapirusIconsFn }

## BEGIN _installQogirIconsFn {
_installQogirIconsFn () {
  # get Qogir-icon-theme and install locally
  git clone https://github.com/vinceliuice/Qogir-icon-theme.git /tmp/Qogir
  chmod u+x /tmp/Qogir/install.sh
  /tmp/Qogir/install.sh -d "${_iconInstallDirectory}"
}
## . END _installQogirIconsFn }

## BEGIN _mainFn {
_mainFn () {
  [ ! -d "${_iconInstallDirectory}" ] \
    && mkdir "${_iconInstallDirectory}"

  _installTelaCircleIconsFn
  _installTelaIconsFn
  _installPapirusIconsFn
  _installQogirIconsFn
}
## . END _mainFn }
### . END: FUNCTION_SECTION }


### BEGIN: MAIN_SECTION {
if [ "${BASH_SOURCE[0]}" = "$0" ]
then
  _mainFn "$@"
fi
### . END: MAIN_SECTION }
