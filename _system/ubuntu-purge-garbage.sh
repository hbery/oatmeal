#!/bin/bash
# vim: ts=4 : sts=4 : sw=4 : et :
#
# purge ubuntu garbage

set -euo pipefail

_purgeTerminalAdsFn () {
    sed -i 's/ENABLED=1/ENABLED=0/g' /etc/default/motd-news
    pro config set apt_news=false
    pro config set apt_news_url=''
}

_removeUbuntuReportFn () {
    ubuntu-report send no
    apt-get remove -yq ubuntu-report
}

_removeAppCrashPopupFn () {
    apt-get remove -yq apport apport-gtk
}

_mainFn () {
    if [[ "$(id -u)" != 0 ]]; then
        echo 1>&2 "Must run as root/sudo!"
        exit 1
    fi

    _removeUbuntuReportFn
    _removeAppCrashPopupFn
    _purgeTerminalAdsFn
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    _mainFn "${@:-}"
fi
