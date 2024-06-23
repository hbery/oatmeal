#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2022
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Install grub2 theme
# ~~~

_repositoryLink="https://github.com/vinceliuice/grub2-themes.git"
_tmpRepoDir="/tmp/grub2-themes"

_cloneRepoFn () {
    git clone "${_repositoryLink}" "${_tmpRepoDir}"
}

_installGrub2ThemeFn () {
    local _boot_theme_dir
    _boot_theme_dir="${1:-}"

    [ ! -d "${_boot_theme_dir}" ] \
        && sudo mkdir "${_boot_theme_dir}"

    cd "${_tmpRepoDir}" || exit 1
    sudo ./install.sh --theme stylish --screen 1080p --icon white --boot "${_boot_theme_dir}"
    cd "${OLDPWD}" || exit 1
}

_updateGrub2Fn () {
    local _boot_config_dir
    _boot_config_dir="${1:-}"

    sudo grub2-mkconfig -o "${_boot_config_dir}"
}

_mainFn () {
    [ ! "$2" ] \
        && echo "usage: $(basename "$0") PATH_TO_GRUB_BOOT_CONFIG PATH_TO_BOOT_THEMES" \
        && exit 1

    local _boot_config_dir _boot_themes_dir
    _boot_config_dir="${1:-}"
    _boot_themes_dir="${2:-}"

    _cloneRepoFn
    _installGrub2ThemeFn "${_boot_themes_dir}"
    _updateGrub2Fn "${_boot_config_dir}"

    echo -e "\e[1mINSTALLATION OF A GRUB2 THEME IS DONE\e[m"
    echo -e "You may now reboot the system with \`sudo reboot now\`."
    echo -e "\nIf grub2 theme has not applied."
    echo -e "Please specify another location for theme installation"
    echo -e "  and copy it again to destined directory."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
