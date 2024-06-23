#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Install dotfiles and stuff across the system (mostly $HOME)
# ~~~

_stowDetected="$(which stow)"
_stowBinary="${_stowDetected:-"/usr/bin/stow"}"

_redClr="\e[1;31m"
_grnClr="\e[1;32m"
_yelClr="\e[1;33m"
_bluClr="\e[1;34m"
_magClr="\e[1;35m"
_cyaClr="\e[1;36m"
_graClr="\e[2;37m"
_bldClr="\e[1m"
_norClr="\e[m"

declare -A _tagMap

 # base tags
 # shellcheck disable=SC2038
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

_errMsg () { >&2 echo -e "${_redClr}ERROR:${_norClr}${_bldClr} $*${_norClr}"; }
_wrnMsg () { echo -e "${_yelClr}WARN:${_norClr}${_bldClr} $*${_norClr}";      }
_sucMsg () { echo -e "${_grnClr}SUCCESS:${_norClr}${_bldClr} $*${_norClr}";   }
_hedMsg () { echo -e "${_magClr}=!=${_norClr}${_bldClr} $*${_norClr}";        }
_endMsg () { echo -e "${_cyaClr}===${_norClr}${_bldClr} $*${_norClr}";        }
_infMsg () { echo -e "${_bldClr}*** $*${_norClr}";                            }
_skpMsg () { echo -e "${_graClr}***${_norClr}${_bldClr} $*${_norClr}";        }
_prgMsg () { echo -e "${_bluClr}|=>${_norClr}${_bldClr} $*${_norClr}";        }

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
for _tag in "${!_tagMap[@]}"; do
  echo -e "  * ${_grnClr}${_tag}${_norClr}: ${_graClr}${_tagMap[${_tag}]}${_norClr}"
done
)
_EOH1
    echo -e "  * ${_grnClr}custom${_norClr}: ${_graClr}what_do_you_want; format \`-t custom:dir1,dir2,..\`${_norClr}"
}

_parseArgumentsFn () {
    # parse commandline arguments for script to run
    while getopts ':hat:IFwWPS' _option; do
        case "${_option}" in
            h)
                _usageFn
                exit
                ;;
            t) _install_tags="${OPTARG}" ;;
            I) _install_icons="set" ;;
            F) _install_fonts="set" ;;
            w) _install_wallpapers="set" ;;
            W) _install_git_wallpapers="set" ;;
            P) _install_packages="set" ;;
            S) _install_system="set" ;;
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

_checkErrCodeAndPrintFn () {
    # wrapper for error checking whether certain action returned success or errors
    # and print it for the user
    local _errcode _msg_on_error _msg_on_success

    _errcode="${1:-}"
    _msg_on_error="${2:-}"
    _msg_on_success="${3:-}"

    if [ "${_errcode}" -ne 0 ]; then
        _errMsg "${_msg_on_error}"
    else
        _sucMsg "${_msg_on_success}"
    fi
}

_installPackagesFn () {
    # TODO 2022-06-08: implement installation script for every package manager
    /bin/true
}

_installDotfilesFn () {
    # install TAGS from accompaning directory to HOME directory
    local _stow_description_dir _stow_destination_dir
    declare -a _tags_to_install

    _stow_description_dir="$(dirname "$0")"
    _stow_destination_dir="${HOME}"
    _tags_to_install=("${@}")

    ${_stowBinary} \
        --dir="${_stow_description_dir}" \
        --target="${_stow_destination_dir}" \
        --stow "${_tags_to_install[@]}"
}

_installFontsFn () {
    local _tmp_fonts_directory _dest_fonts_directory _errcode

    _tmp_fonts_directory="${1:-}"
    _dest_fonts_directory="${2:-}"

    _hedMsg "Starting FONTS installation."
    "$(dirname "$0")/_fonts/install-fonts.sh" -a \
        -t "${_tmp_fonts_directory}" \
        -d "${_dest_fonts_directory}"
    _errcode="$?"
    _endMsg "Ended FONTS installation."
    _checkErrCodeAndPrintFn "${_errcode}" \
        "FONTS installation failed." \
        "FONTS installation succeeded."

    return ${_errcode}
}

_installIconsFn () {
    local _tmp_icons_directory _dest_icons_directory _errcode

    _tmp_icons_directory="${1:-}"
    _dest_icons_directory="${2:-}"

    _hedMsg "Starting ICONS installation."
    ICON_TMPDIR="${_tmp_icons_directory}" ICON_INSTALLDIR="${_dest_icons_directory}" \
        "$(dirname "$0")/_icons/install-icons.sh"
    _errcode="$?"
    _endMsg "Ended ICONS installation."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "ICONS installation failed." \
        "ICONS installation succeeded."

    return ${_errcode}
}

_getAndInstallWallpapersFn () {
    local _wallpapers_direcory

    _wallpapers_direcory="${1:-}"

    _hedMsg "Linking brought WALLPAPERS to ${_wallpapers_direcory}."
    while read -r _image; do
      ln -s "$(realpath "${_image}")" "$(realpath "${_wallpapers_direcory}")/${_image}"
    done <<<"$(find "$(dirname "$0")/_images" -type f -regextype posix-extended -regex ".*(jpg|png)" -print)"
}

_getAndInstallGitWallpapersFn () {
    local _dest_wallpapers_directory _errcode

    _dest_wallpapers_directory="${1:-}"

    _hedMsg "Downloading GIT WALLPAPERS (https://gitlab.com/dwt1/wallpapers.git) into ${_dest_wallpapers_directory}"
    git clone --quiet \
        "https://gitlab.com/dwt1/wallpapers.git" \
        "${_dest_wallpapers_directory}"
    _errcode="$?"
    _endMsg "Ended GIT WALLPAPERS download."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "GIT WALLPAPERS download failed." \
        "GIT WALLPAPERS download succeded."

    return ${_errcode}
}

_applyQtKdeChangesFn () {
    local _errcode

    # local _tmp_dir="${1:-}"
    # local _dest_dir="${2:-}"

    _hedMsg "Applying QT/KDE themes."
    "$(dirname "$0")/_installation_scripts/install-kde-themes.sh"
    _errcode="$?"
    _endMsg "Ended QT/KDE theme application."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "QT/KDE THEMES application failed." \
        "QT/KDE THEMES application succeded."

    return ${_errcode}
}

_applyGtkXfceChangesFn () {
    local _errcode

    # local _tmp_dir="${1:-}"
    # local _dest_dir="${2:-}"

    _hedMsg "Applying GTK/XFCE themes."
    "$(dirname "$0")/_installation_scripts/install-xfce-themes.sh"
    _errcode="$?"
    _endMsg "Ended GTK/XFCE theme application."

    _checkErrCodeAndPrintFn "${_errcode}" \
        "GTK/XFCE THEMES application failed." \
        "GTK/XFCE THEMES application succeded."
    return ${_errcode}
}

_applySystemChangesFn () {
    # TODO 2022-06-10: implement applying System changes
    /bin/true
}

_cleanupFn () {
    # TODO 2022-06-10: implement cleanup functionality
    [ -d "/tmp/fonts-tmp" ] && rm -rfv "/tmp/fonts-tmp"
    [ -d "/tmp/icons-tmp" ] && rm -rfv "/tmp/icons-tmp"
}

_mainFn () {
    # parse arguments
    _parseArgumentsFn "$@"

    # install PACKAGES
    if [ "${_install_packages}" ] || [ "${_install_all}" ]; then
        _infMsg "Installing PACKAGES .."
        _installPackagesFn
    fi

    # install TAGS
    if [ "${_install_tags}" ] || [ "${_install_all}" ]; then
        _infMsg "Installing TAGS .."
        declare -a _tag_list

        case "${_install_tags}" in
            "custom:"*)
                _infMsg "Using CUSTOM tags"
                IFS=',' read -r -a _tag_list <<<"${_install_tags/custom:/}"
                ;;
            *)
                for _tag in ${_install_tags}; do
                  while IFS=' ' read -r _line; do _tag_list+=("${_line}"); done <<<"${_tagMap[${_tag}]}"
                done
                ;;
        esac

        _infMsg "TAGS to install: ${_tag_list[*]}"
        _installDotfilesFn "${_tag_list[@]}"
    fi

    # install ICONS
    if [ "${_install_icons}" ] || [ "${_install_all}" ]; then
        _infMsg "Installing ICONS .."
        [ ! -d "/tmp/icons-tmp" ] && mkdir -pv "/tmp/icons-tmp"
        _installIconsFn "/tmp/icons-tmp" "${HOME}/.local/share/icons"
    fi

    # install FONTS
    if [ "${_install_fonts}" ] || [ "${_install_all}" ]; then
        _infMsg "Installing FONTS .."
        [ ! -d "/tmp/fonts-tmp" ] && mkdir -pv "/tmp/fonts-tmp"
        _installFontsFn "/tmp/fonts-tmp" "${HOME}/.local/share/fonts"
    fi

    # install WALLPAPERS
    if [ "${_install_wallpapers}" ] || [ "${_install_all}" ]; then
        _infMsg "Installing WALLPAPERS .."
        _getAndInstallWallpapersFn "${HOME}/Pictures"
    fi

    # install GIT WALLPAPERS
    if [ "${_install_git_wallpapers}" ] || [ "${_install_all}" ]; then
        _infMsg "Installing GIT WALLPAPERS .."
        _getAndInstallGitWallpapersFn "${HOME}/Pictures/dt-wallpapers"
    fi

    # apply SYSTEM changes
    if [ "${_install_system}" ] || [ "${_install_all}" ]; then
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

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    _mainFn "$@"
fi
