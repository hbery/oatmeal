#!/bin/bash
#
# install SDDM theme

_theme_name="Ant-Dark"
_repository="https://github.com/EliverLara/Ant"
_rpath="kde/Dark/sddm"
_tmp_dir=$(mktemp -d)

_downloadThemeFn () {
    svn export "${_repository}/trunk/${_rpath}" "${_tmp_dir}"
}

_setupSDDMThemeFn () {
    _dst_bg="$(sed -rn '/^Background=(.*)/\1/p' "${_tmp_dir}/${_theme_name}/theme.conf" | tr -d '"')"
    cp "$(dirname "$0")/login_bg.jpg" "${_tmp_dir}/${_theme_name}/${_dst_bg}"

    mv "${_tmp_dir}/${_theme_name}" "/usr/share/sddm/themes"

    if [[ "${XDG_CURRENT_DESKTOP}" =~ KDE|kde ]]; then
        sed -ri 's/(Current=)(.*)/\1'"${_theme_name}"'/' /etc/sddm.conf.d/kde_settings.conf
    else
        if [ -e "/etc/sddm.conf" ]; then
            if [ "$(grep -c "Current" /etc/sddm.conf)" = 1 ]; then
                sed -ri 's/(Current=)(.*)/\1'"${_theme_name}"'/' /etc/sddm.conf
            else
                echo -e "[Theme]\nCurrent=${_theme_name}" >> /etc/sddm.conf
            fi
        else
            echo -e "[Theme]\nCurrent=${_theme_name}" > /etc/sddm.conf
        fi
    fi
}

_mainFn () {
    _downloadThemeFn
    _setupSDDMThemeFn
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    _mainFn "$@"
fi
