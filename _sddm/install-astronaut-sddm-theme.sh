#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# install astronaut sddm theme

_tmpDirTemplate="/tmp/sddm-theme-XXXXXX"
_tmpDir="$(mktemp -d "${_tmpDirTemplate}")"
_allowedSystems="fedora debian ubuntu"
_fontName="MonaspiceAr Nerd Font"
_fallbackFontName="Open Sans"
_gitRepository="https://github.com/Keyitdev/sddm-astronaut-theme"

_checkSystemFn () {
    if ! grep -qP "^ID(|_LIKE)=(${_allowedSystems// /|})$" /etc/os-release; then
        echo >&2 "This script is destined for debian-based systems."
        exit 1
    fi
}

_installPrerequisitiesFn () {
    local _distro
    _distro="${1:-}"
    case "${_distro}" in
    "debian"|"ubuntu")
        apt-get install -yq --no-install-recommends \
            qml-module-qtquick-layouts \
            qml-module-qtquick-controls2 \
            libqt6svg6
        ;;
    "fedora")
        dnf install -yq \
            qt6-qtsvg
        ;;
    *)
        echo "Distro '${_distro}' not supported."
    esac
}

_cloneThemeRepoFn () {
    git clone "${_gitRepository}" "${_tmpDir}/astronaut"
    if [[ "$(find "${HOME}/.local/share/fonts/" -type f -name "OpenSans*" | wc -l)" == 0 ]]; then
        cp "${_tmpDir}/astronaut/Fonts/*" "/usr/share/fonts/"
        fc-cache -v
    fi
}

_overrideThemeOptionsFn () {
    fc-list | grep -q "${_fontName}"; [[ ! $? ]] && _fontName="${_fallbackFontName}"

    # set wallpaper
    cp "$(dirname "$0")/login_bg.jpg" "${_tmpDir}/astronaut/Backgrounds/bg.jpg"

    # change options
    sed -ri 's/CustomBackground=(.*)/CustomBackground="true"/' "${_tmpDir}/astronaut/Themes/theme1.conf"
    sed -ri 's/Background=(.*)/Background="Backgrounds/bg.jpg"/' "${_tmpDir}/astronaut/Themes/theme1.conf"
    sed -ri 's/Font=(.*)/Font="'"${_fontName}"'"/' "${_tmpDir}/astronaut/Themes/theme1.conf"
    sed -ri 's/FontSize=(.*)/FontSize=10/' "${_tmpDir}/astronaut/Themes/theme1.conf"

    sed -ri 's/Name=(.*)/Name=astronaut/' "${_tmpDir}/astronaut/metadata.desktop"
    sed -ri 's/Theme-Id=(.*)/Theme-Id=astronaut/' "${_tmpDir}/astronaut/metadata.desktop"
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
    _installPrerequisitiesFn "$(sed -nr 's/^ID=(.*)$/\1/p' /etc/os-release)"
    _cloneThemeRepoFn
    _overrideThemeOptionsFn
    _setThemeFn "astronaut"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
