#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Swap snap to flatpak
# ~~~

set -euo pipefail

_purgeSnapdFn () {
    while [ "$(snap list 2>/dev/null | wc -l)" -gt 0 ]; do
        for _snap_pkg in $(snap list 2>/dev/null | tail -n +2 | cut -d ' ' -f 1); do
            snap remove --purge "${_snap_pkg}"
        done
    done

    systemctl stop snapd \
        && systemctl disable snapd \
        && systemctl mask snapd
    apt-get purge -yq snapd

    rm -rf /snap /var/lib/snapd
    for _user_path in /home/*; do
        rm -rf "${_user_path}/snap"
    done

    cat <<- _EOH1 | tee "/etc/apt/preferences.d/nosnap.pref"
Package: snapd
Pin: release a=*
Pin-Priority: -10
_EOH1
}

_setupFlatpakFn () {
    apt-get install flatpak -y
    flatpak remote-add --if-not-exists flathub "https://flathub.org/repo/flathub.flatpakrepo"
}

_mainFn () {
    if [[ "$(id -u)" != 0 ]]; then
        echo 1>&2 "Must run as root/sudo!"
        exit 1
    fi

    _purgeSnapdFn
    _setupFlatpakFn
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
