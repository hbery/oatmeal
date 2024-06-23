#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# install catppuccin-macchiato sddm theme

_tmpDirTemplate="/tmp/sddm-theme-XXXXXX"
_tmpDir="$(mktemp -d "${_tmpDirTemplate}")"
_allowedSystems="debian ubuntu"
_fontName="MonaspiceAr Nerd Font"
_fallbackFontName="Noto Sans"

_checkSystemFn () {
    if ! grep -qP "^ID(|_LIKE)=(${_allowedSystems// /|})$" /etc/os-release; then
        echo >&2 "This script is destined for debian-based systems."
        exit 1
    fi
}

_installPrerequisitiesFn () {
    apt-get install -yq --no-install-recommends \
        qml-module-qtquick-layouts \
        qml-module-qtquick-controls2 \
        libqt6svg6
}

_downloadThemeAndUnpackFn () {
    wget -q -O "${_tmpDir}/catppuccin-macchiato.zip" "https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-macchiato.zip"
    unzip "${_tmpDir}/catppuccin-macchiato.zip" -d "${_tmpDir}"
}

_overrideThemeOptionsFn () {
    fc-list | grep -q "${_fontName}"; [[ ! $? ]] && _fontName="${_fallbackFontName}"

    # set wallpaper
    cp "$(dirname "$0")/login_bg.jpg" "${_tmpDir}/catppuccin-macchiato/backgrounds/bg.jpg"

    # change options
    sed -ri 's/CustomBackground=(.*)/CustomBackground="true"/' "${_tmpDir}/catppuccin-macchiato/theme.conf"
    sed -ri 's/Background=(.*)/Background="backgrounds/bg.jpg"/' "${_tmpDir}/catppuccin-macchiato/theme.conf"
    sed -ri 's/Font=(.*)/Font="'"${_fontName}"'"/' "${_tmpDir}/catppuccin-macchiato/theme.conf"
    sed -ri 's/FontSize=(.*)/FontSize=10/' "${_tmpDir}/catppuccin-macchiato/theme.conf"
}

_setThemeFn () {
    local _theme_name
    _theme_name="${1:-}"

    if [[ "${XDG_CURRENT_DESKTOP}" =~ KDE|kde ]]; then
        sed -ri 's#(Current=)(.*)#\1'"${_theme_name}"'#' "/etc/sddm.conf.d/kde_settings.conf"
    else
        if [ -e "/etc/sddm.conf" ]; then
            if [ "$(grep -c "Current" /etc/sddm.conf)" = "1" ]; then
                sed -ri 's#(Current=)(.*)#\1'"${_theme_name}"'#' "/etc/sddm.conf"
            else
                printf "[Theme]\nCurrent=%s\n" "${_theme_name}" >> "/etc/sddm.conf"
            fi
        else
            printf "[Theme]\nCurrent=%s\n" "${_theme_name}" > "/etc/sddm.conf"
        fi
    fi
}

_mainFn () {
    if [[ $(id -u) -ne 0 ]]; then
        echo >&2 "Must run as root/sudo!"
        exit 1
    fi

    _checkSystemFn
    _installPrerequisitiesFn
    _downloadThemeAndUnpackFn
    _overrideThemeOptionsFn
    _setThemeFn "catppuccin-macchiato"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
