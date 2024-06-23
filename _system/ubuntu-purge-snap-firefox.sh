#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Purge snap firefox from ubuntu
# ~~~

set -euo pipefail

_switchFirefoxSnap2DebFn () {
    { dpkg -l | grep -q firefox; } &>/dev/null;           _firefox_installed=$?
    { grep -q "ID=ubuntu" /etc/os-release; } &>/dev/null; _is_ubuntu=$?
    if [[ ${_firefox_installed} -eq 0 && ${_is_ubuntu} -eq 0 ]]; then
        apt-get purge -yq firefox
        snap remove --purge firefox
    fi

    wget -q "https://packages.mozilla.org/apt/repo-signing-key.gpg" \
        -O "/etc/apt/keyrings/packages.mozilla.org.asc"
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
        | tee "/etc/apt/sources.list.d/mozilla.list"

    cat <<- _EOH1 | tee "/etc/apt/preferences.d/mozilla"
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
_EOH1
}

_mainFn () {
    if [[ "$(id -u)" != 0 ]]; then
        echo 1>&2 "Must run as root/sudo!"
        exit 1
    fi

    _switchFirefoxSnap2DebFn
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
