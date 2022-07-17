#!/bin/sh
#
# simple bootstrapping script to get and engage install-scripts for icons

_iconInstallDirectory="${HOME}/.local/share/icons"
[ ! -d "${_iconInstallDirectory}" ] && mkdir "${_iconInstallDirectory}"

# get Tela-circle-icon-theme and install locally
git clone https://github.com/vinceliuice/Tela-circle-icon-theme.git /tmp/Tela-circle
chmod u+x /tmp/Tela-circle/install.sh
/tmp/Tela-circle/install.sh -a -d "${_iconInstallDirectory}"

# get Tela-icon-theme and install locally
git clone https://github.com/vinceliuice/Tela-icon-theme.git /tmp/Tela
chmod u+x /tmp/Tela/install.sh
/tmp/Tela/install.sh -a -d "${_iconInstallDirectory}"

# get papirus-icon-theme and install locally
git clone https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git /tmp/papirus
chmod u+x /tmp/papirus/install.sh
DESTDIR="${_iconInstallDirectory}" /tmp/papirus/install.sh
