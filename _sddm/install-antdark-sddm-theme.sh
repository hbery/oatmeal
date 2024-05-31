#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# install AntDark SDDM theme

_sddm_themes_dir="/usr/share/sddm/themes"
_theme_name="Ant-Dark"
_repository="https://github.com/EliverLara/Ant"
_rpath="kde/Dark/sddm"
_tmp_dir=$(mktemp -d)

_full_dir_path="${_tmp_dir}"

_preCleanThemeDirFn () {
    rm -rf "${_sddm_themes_dir:?}/${_theme_name}"
}

_postCleanThemeDirFn () {
    rm -rf "${_tmp_dir}"
}

_downloadThemeFn () {
    # svn export "${_repository}/trunk/${_rpath}" "${_tmp_dir}"
    git clone --no-checkout --depth 1 --sparse "${_repository}" "${_tmp_dir}" \
    && cd "${_tmp_dir}" \
    && git sparse-checkout set "${_rpath}" \
    && git switch master

    _full_dir_path="${_tmp_dir}/${_rpath}/${_theme_name}"
}

_setupSDDMThemeFn () {
    mkdir -p "${_full_dir_path}/backgrounds"
    cp "$(realpath "$(dirname "$0")")/login_bg.jpg" "${_full_dir_path}/backgrounds/login_bg.jpg"
    sed -ri 's#^Background=.*#Background="backgrounds/login_bg.jpg"#' "${_full_dir_path}/theme.conf"

    mv "${_full_dir_path}" "${_sddm_themes_dir}/"

    if [[ "${XDG_CURRENT_DESKTOP}" =~ KDE|kde ]]; then
        sed -ri 's#(Current=)(.*)#\1'"${_theme_name}"'#' /etc/sddm.conf.d/kde_settings.conf
    else
        if [ -e "/etc/sddm.conf" ]; then
            if [ "$(grep -c "Current" /etc/sddm.conf)" = "1" ]; then
                sed -ri 's#(Current=)(.*)#\1'"${_theme_name}"'#' /etc/sddm.conf
            else
                printf "[Theme]\nCurrent=%s\n" "${_theme_name}" >> /etc/sddm.conf
            fi
        else
            printf "[Theme]\nCurrent=%s\n" "${_theme_name}" > /etc/sddm.conf
        fi
    fi
}

_mainFn () {
    _preCleanThemeDirFn

    _downloadThemeFn
    _setupSDDMThemeFn

    _postCleanThemeDirFn
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    _mainFn "$@"
fi
