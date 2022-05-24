#!/bin/bash
# vim: ft=bash : ts=2 : sw=2 :
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
_tagMap[all]="$(find $(dirname "$0") -maxdepth 1 -type d -regex "$(dirname "$0")/[^_\.]*" -exec basename {} \; | xargs)"
_tagMap[base]="sys xdefaults bash shell zsh vim nvim tmux screen git htop starship"
_tagMap[base-gui]="screenlayout alacritty xterm urxvt gtk2 gtk3 mpv pcmanfm firefox"
_tagMap[add-gui]="mypaint vscode brave spacefm"
_tagMap[kde]="kde konsole yakuake latte rofi"
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
_infMsg () { echo -e "${_bldClr}*** $*${_norClr}";                  }
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
  -T TAGS  Install specific tags, comma separated list.
  -I       [WIP] Install icons. (_icons/install-icons.sh)
  -F       Install fonts. (_fonts/install-fonts.sh)
  -P       [WIP] Install packages specific to the distribution/package manager.
             (_packages/install-packages.sh)
  -w       Install wallpapers shipped with this repository
             (_images/*) in ${HOME}/Pictures directory.
  -W       Install beautiful wallpapers from DistroTube's repository
             into ${HOME}/Pictures directory. (https://gitlab.com/dwt1/wallpapers.git)
  -S       [WIP] Install system tweaks. (Outside of ${HOME} directory)

List of available TAGS:
$( for _tag in "${!_tagMap[@]}"
do
  echo -e "  * ${_grnClr}${_tag}${_norClr}: ${_graClr}${_tagMap[${_tag}]}${_norClr}"
done
)
_EOH1
}
## . END _usageFn }

## BEGIN _parseArgumentsFn {
_parseArgumentsFn () {
  while getopts ':hat:IFwWPS' _option; do
    case "${_option}" in
      h)
        _usageFn
        exit
        ;;
      a)
        _install_all="set"
        _install_tags="all"
        ;;
      t) _install_tags="${OPTARG}"      ;;
      I) _install_icons="set"           ;;
      F) _install_fonts="set"           ;;
      w) _install_wallpapers="set"      ;;
      W) _install_git_wallpapers="set"  ;;
      P) _install_packages="set"        ;;
      S) _install_system="set"          ;;
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

## BEGIN _installPackagesFn {
_installPackagesFn () {
  true
}
## . END _installPackagesFn }

## BEGIN _installDotfilesFn {
_installDotfilesFn () {
  echo -e "$@"
  true
}
## . END _installDotfilesFn }

## BEGIN _installFontsFn {
_installFontsFn () {
  true
}
## . END _installFontsFn }

## BEGIN _installIconsFn {
_installIconsFn () {
  true
}
## . END _installIconsFn }

## BEGIN _getAndInstallWallpapersFn {
_getAndInstallWallpapersFn () {
  true
}
## . END _getAndInstallWallpapersFn }

## BEGIN _getAndInstallGitWallpapersFn {
_getAndInstallGitWallpapersFn () {
  true
}
## . END _getAndInstallGitWallpapersFn }

## BEGIN _applyQtKdeChangesFn {
_applyQtKdeChangesFn () {
  true
}
## . END _applyQtKdeChangesFn }

## BEGIN _applyGtkXfceCahngesFn {
_applyGtkXfceCahngesFn () {
  true
}
## . END _applyGtkXfceCahngesFn }

## BEGIN _applySystemChangesFn {
_applySystemChangesFn () {
  true
}
## . END _applySystemChangesFn }

## BEGIN _cleanupFn {
_cleanupFn () {
  true
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
    for _tag in ${_install_tags}
    do
      _tag_list+=(${_tagMap[${_tag}]})
    done
    _installDotfilesFn "${_tag_list[@]}"
  fi

  # install ICONS
  if [ "${_install_icons}" ] || [ "${_install_all}" ]
  then
    _infMsg "Installing ICONS .."
    _installIconsFn "/tmp/icons-tmp" "${HOME}/.local/share/icons"
  fi

  # install FONTS
  if [ "${_install_fonts}" ] || [ "${_install_all}" ]
  then
    _infMsg "Installing FONTS .."
    _installFontsFn "/tmp/fonts-tmp" "${HOME}/.local/share/fonts"
  fi

  # install WALLPAPERS
  if [ "${_install_wallpapers}" ] || [ "${_install_all}" ]
  then
    _infMsg "Installing WALLPAPERS .."
    _getAndInstallWallpapersFn
  fi

  # install GIT WALLPAPERS
  if [ "${_install_git_wallpapers}" ] || [ "${_install_all}" ]
  then
    _infMsg "Installing GIT WALLPAPERS .."
    _getAndInstallGitWallpapersFn
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
  _cleanupFn
}
## . END _mainFn }
### . END: FUNCTION_SECTION }

### BEGIN: MAIN_SECTION {
if [ "${BASH_SOURCE[0]}" = "$0" ]
then
  _mainFn "$@"
fi
### . END: MAIN_SECTION }
