#!/bin/bash
# vim: ts=4 : sw=4 : et :
# ~~~
# Date: 2022
# Author: Adam Twardosz (github.com/hbery)
# Purpose: install dotfiles and stuff across the system (mostly $HOME)
# ~~~

### BEGIN: SCRIPT_OPTIONS {
### . END: SCRIPT_OPTIONS }

### BEGIN: GLOBAL_SECTION {
_stowBinary="/usr/bin/stow"
### . END: GLOBAL_SECTION }

### BEGIN: COLOR_PALETTE {
_redClr="\e[1;31m"
_grnClr="\e[1;32m"
_yelClr="\e[1;33m"
_bluClr="\e[1;34m"
_magClr="\e[1;35m"
_cyaClr="\e[1;36m"
_graClr="\e[2;37m"
_bldClr="\e[1m"
_norClr="\e[m"
### . END: COLOR_PALETTE }

### BEGIN: TAG_SECTION {
declare -A _tagMap

 # base tags
_tagMap[all]="$(find "$(dirname "$0")" \
                  -maxdepth 1 \
                  -type d \
                  -regex "$(dirname "$0")/[^_\.]*" \
                  -exec basename {} \; \
                | xargs)"
_tagMap[base]="sys xdefaults bash shell zsh vim nvim tmux screen git htop starship"
_tagMap[base-gui]="screenlayout alacritty xterm urxvt gtk2 gtk3 mpv pcmanfm firefox"
_tagMap[add-gui]="mypaint vscode brave spacefm"
_tagMap[kde]="kde konsole yakuake latte rofi"
_tagMap[scripts]="scripts"
_tagMap[xfce]="xfce plank rofi"
_tagMap[qtile]="qtilewm dunst rofi nitrogen"
_tagMap[awesome]="awesomewm dunst rofi nitrogen"
_tagMap[bspwm]="bspwm sxhkd dunst rofi nitrogen"
### . END: TAG_SECTION }

### BEGIN: FUNCTION_SECTION {
## BEGIN _xxxMsg {
_errMsg () { >&2 echo -e "${_redClr}ERROR:${_norClr}${_bldClr} $*${_norClr}"; }
_wrnMsg () { echo -e "${_yelClr}WARN:${_norClr}${_bldClr} $*${_norClr}";      }
_sucMsg () { echo -e "${_grnClr}SUCCESS:${_norClr}${_bldClr} $*${_norClr}";   }
_hedMsg () { echo -e "${_magClr}=!=${_norClr}${_bldClr} $*${_norClr}";        }
_endMsg () { echo -e "${_cyaClr}===${_norClr}${_bldClr} $*${_norClr}";        }
_infMsg () { echo -e "${_bldClr}*** $*${_norClr}";                            }
_skpMsg () { echo -e "${_graClr}***${_norClr}${_bldClr} $*${_norClr}";        }
_prgMsg () { echo -e "${_bluClr}|=>${_norClr}${_bldClr} $*${_norClr}";        }
## . END _xxxMsg }

## BEGIN _usageFn {
_usageFn () {
    cat << _EOH1
usage: $(basename "$0") [-h] [-a] [-t TAGS] [-I] [-F] [-P] [-w] [-W] [-S]

  Install dotfiles from this directory. Also ICONS, FONTS, PACKAGES,
    WALLPAPERS can be installed in the right place.

  -h       Show this help.
  -a       Install all things that this script provides. Specifically:
             (dotfiles[tags:all], icons, fonts, packages, wallpapers[git])
  -t TAGS  Install specific tags, comma separated list.
  -I       [WIP] Install icons. (_icons/install-icons.sh)
  -F       Install fonts. (_fonts/install-fonts.sh)
  -P       [WIP] Install packages specific to the distribution/package manager.
             (_packages/install-packages.sh)
  -w       Install wallpapers shipped with this repository
             (_images/*) in ${HOME}/Pictures directory.
  -W       Install beautiful wallpapers from DistroTube's repository
             into ${HOME}/Pictures directory.
             (https://gitlab.com/dwt1/wallpapers.git)
  -S       [WIP] Install system tweaks. (Outside of ${HOME} directory)

List of available TAGS:
$(
for _tag in "${!_tagMap[@]}"
do
  echo -e "  * ${_grnClr}${_tag}${_norClr}: ${_graClr}${_tagMap[${_tag}]}${_norClr}"
done
)
_EOH1
    echo -e "  * ${_grnClr}custom${_norClr}: ${_graClr}what_do_you_want; format \`-t custom:dir1,dir2,..\`${_norClr}"
}
## . END _usageFn }

## BEGIN _parseArgumentsFn {
 # parse commandline arguments for script to run
_parseArgumentsFn () {
    while getopts ':hat:IFwWPS' _option
    do
        case "${_option}" in
            h)
                _usageFn
                exit
                ;;
            t) _install_tags="${OPTARG}"            ;;
            I) _install_icons="set"                     ;;
            F) _install_fonts="set"                     ;;
            w) _install_wallpapers="set"            ;;
            W) _install_git_wallpapers="set"    ;;
            P) _install_packages="set"                ;;
            S) _install_system="set"                    ;;
            a)
                _install_all="set"
                _install_tags="all"
                ;;
            :)
                _errMsg "No ARGUMENT specified for option: -${OPTARG}"
                _usageFn
                exit 1
                ;;
            *)
                _errMsg "Unknown option: -${OPTARG}"
                _usageFn
                exit 1
                ;;
        esac
    done
}
## . END _parseArgumentsFn }

## BEGIN _checkErrCodeAndPrintFn {
 # wrapper for error checking whether certain action returned success or errors
 # and print it for the user
_checkErrCodeAndPrintFn () {
    local _errcode="${1:-}"
    local _msg_on_error="${2:-}"
    local _msg_on_success="${3:-}"

    if [ "${_errcode}" -ne 0 ]
    then
        _errMsg "${_msg_on_error}"
    else
        _sucMsg "${_msg_on_success}"
    fi
}
## . END _checkErrCodeAndPrintFn }

## BEGIN _installPackagesFn {
_installPackagesFn () {
    # TODO 2022-06-08: implement installation script for every package manager
    /bin/true
}
## . END _installPackagesFn }

## BEGIN _installDotfilesFn {
 # install TAGS from accompaning directory to HOME directory
_installDotfilesFn () {
    local _stow_description_dir="$(dirname "$0")"
    local _stow_destination_dir="${HOME}"
    declare -a _tags_to_install=("${@}")

    ${_stowBinary} \
        --verbose=5 \
        --dir="${_stow_description_dir}" \
        --target="${_stow_destination_dir}" \
        --stow "${_tags_to_install[@]}"
}
## . END _installDotfilesFn }

## BEGIN _installFontsFn {
_installFontsFn () {
    local _tmp_fonts_directory="${1:-}"
    local _dest_fonts_directory="${2:-}"

    _hedMsg "Starting FONTS installation."
    $(dirname "$0")/_fonts/install-fonts.sh -a \
        -t "${_tmp_fonts_directory}" \
        -d "${_dest_fonts_directory}"
    local _errcode="$?"
    _endMsg "Ended FONTS installation."
    _checkErrCodeAndPrintFn "${_errcode}" \
        "FONTS installation failed." \
        "FONTS installation succeeded."
    return ${_errcode}
}
## . END _installFontsFn }

## BEGIN _installIconsFn {
_installIconsFn () {
    local _tmp_icons_directory="${1:-}"
    local _dest_icons_directory="${2:-}"

    _hedMsg "Starting ICONS installation."
    ICON_TMPDIR="${_tmp_icons_directory}" ICON_INSTALLDIR="${_dest_icons_directory}" \
        "$(dirname "$0")/_icons/install-icons.sh"
    local _errcode="$?"
    _endMsg "Ended ICONS installation."
    _checkErrCodeAndPrintFn "${_errcode}" \
        "ICONS installation failed." \
        "ICONS installation succeeded."
    return ${_errcode}
}
## . END _installIconsFn }

## BEGIN _getAndInstallWallpapersFn {
_getAndInstallWallpapersFn () {
    local _wallpapers_direcory="${1:-}"

    _hedMsg "Linking brought WALLPAPERS to ${_wallpapers_direcory}."
    ln -s "$(find "$(dirname "$0")/_images" -name "*.{jpg,png}" | xargs)" "$(realpath "${_wallpapers_direcory}")/"
}
## . END _getAndInstallWallpapersFn }

## BEGIN _getAndInstallGitWallpapersFn {
_getAndInstallGitWallpapersFn () {
    local _dest_wallpapers_directory="${1:-}"

    _hedMsg "Downloading GIT WALLPAPERS (https://gitlab.com/dwt1/wallpapers.git) into ${_dest_wallpapers_directory}"
    git clone --quiet \
        "https://gitlab.com/dwt1/wallpapers.git" \
        "${_dest_wallpapers_directory}"
    local _errcode="$?"
    _endMsg "Ended GIT WALLPAPERS download."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "GIT WALLPAPERS download failed." \
        "GIT WALLPAPERS download succeded."
    return ${_errcode}
}
## . END _getAndInstallGitWallpapersFn }

## BEGIN _applyQtKdeChangesFn {
_applyQtKdeChangesFn () {
    # local _tmp_dir="${1:-}"
    # local _dest_dir="${2:-}"

    _hedMsg "Applying QT/KDE themes."
    "$(dirname "$0")/_installation_scripts/install-kde-themes.sh"
    local _errcode="$?"
    _endMsg "Ended QT/KDE theme application."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "QT/KDE THEMES application failed." \
        "QT/KDE THEMES application succeded."
    return ${_errcode}
}
## . END _applyQtKdeChangesFn }

## BEGIN _applyGtkXfceCahngesFn {
_applyGtkXfceChangesFn () {
    # local _tmp_dir="${1:-}"
    # local _dest_dir="${2:-}"

    _hedMsg "Applying GTK/XFCE themes."
    "$(dirname "$0")/_installation_scripts/install-xfce-themes.sh"
    local _errcode="$?"
    _endMsg "Ended GTK/XFCE theme application."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "GTK/XFCE THEMES application failed." \
        "GTK/XFCE THEMES application succeded."
    return ${_errcode}
}
## . END _applyGtkXfceCahngesFn }

## BEGIN _applySystemChangesFn {
_applySystemChangesFn () {
    # TODO 2022-06-10: implement applying System changes
    true
}
## . END _applySystemChangesFn }

## BEGIN _cleanupFn {
_cleanupFn () {
    # TODO 2022-06-10: implement cleanup functionality
    [ -d "/tmp/fonts-tmp" ] && rm -rfv "/tmp/fonts-tmp"
    [ -d "/tmp/icons-tmp" ] && rm -rfv "/tmp/icons-tmp"
}
## . END _cleanupFn }

## BEGIN _mainFn {
_mainFn () {
    # parse arguments
    _parseArgumentsFn "$@"

    # install PACKAGES
    if [ "${_install_packages}" ] || [ "${_install_all}" ]
    then
        _infMsg "Installing PACKAGES .."
        _installPackagesFn
    fi

    # install TAGS
    if [ "${_install_tags}" ] || [ "${_install_all}" ]
    then
        _infMsg "Installing TAGS .."
        declare -a _tag_list
        case "${_install_tags}" in
            "custom:"*)
                _infMsg "Using CUSTOM tags"
                while IFS=',' read -r _line; do _tag_list+=("${_line}"); done <<<"${_install_tags##*:}"
                ;;
            *)
                for _tag in ${_install_tags}
                do
                  while IFS=' ' read -r _line; do _tag_list+=("${_line}"); done <<<"${_tagMap[${_tag}]}"
                done
                ;;
        esac
        _infMsg "TAGS to install: ${_tag_list[*]}"
        _installDotfilesFn "${_tag_list[@]}"
    fi

    # install ICONS
    if [ "${_install_icons}" ] || [ "${_install_all}" ]
    then
        _infMsg "Installing ICONS .."
        [ ! -d "/tmp/icons-tmp" ] && mkdir -pv "/tmp/icons-tmp"
        _installIconsFn "/tmp/icons-tmp" "${HOME}/.local/share/icons"
    fi

    # install FONTS
    if [ "${_install_fonts}" ] || [ "${_install_all}" ]
    then
        _infMsg "Installing FONTS .."
        [ ! -d "/tmp/fonts-tmp" ] && mkdir -pv "/tmp/fonts-tmp"
        _installFontsFn "/tmp/fonts-tmp" "${HOME}/.local/share/fonts"
    fi

    # install WALLPAPERS
    if [ "${_install_wallpapers}" ] || [ "${_install_all}" ]
    then
        _infMsg "Installing WALLPAPERS .."
        _getAndInstallWallpapersFn "${HOME}/Pictures"
    fi

    # install GIT WALLPAPERS
    if [ "${_install_git_wallpapers}" ] || [ "${_install_all}" ]
    then
        _infMsg "Installing GIT WALLPAPERS .."
        _getAndInstallGitWallpapersFn "${HOME}/Pictures/dt-wallpapers"
    fi

    # apply SYSTEM changes
    if [ "${_install_system}" ] || [ "${_install_all}" ]
    then
        _infMsg "Applying QT themes/changes .."
        _applyQtKdeChangesFn

        _infMsg "Applying GTK themes/changes .."
        _applyGtkXfceCahngesFn

        _infMsg "Applying System changes .."
        _applySystemChangesFn
    fi

    # cleanup
    _infMsg "Cleaning up .."
    _cleanupFn
    _endMsg "End of Script."
}
## . END _mainFn }
### . END: FUNCTION_SECTION }

### BEGIN: MAIN_SECTION {
if [ "${BASH_SOURCE[0]}" = "$0" ]
then
    _mainFn "$@"
fi
### . END: MAIN_SECTION }
