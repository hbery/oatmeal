#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# Date: 2022
# Author: Adam Twardosz (github.com/hbery)
# Purpose: install fonts in .local/share/fonts direcory
# ~~~

### BEGIN: SCRIPT_OPTIONS {
_localFontDirectory="${HOME}/.local/share/fonts"
_tempFontDirectory="/tmp/fonts"
_nerdFontLink="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1"
_nerdFontList="FantasqueSansMono FiraCode FiraMono Go-Mono Hack Inconsolata InconsolataGo Meslo RobotoMono SourceCodePro CascadiaCode JetBrainsMono ComicShannsMono VictorMono Monaspace"
_otherFontList="Roboto;https://fonts.google.com/download?family=Roboto
                Montserrat;https://fonts.google.com/download?family=Montserrat
                Noto-Emoji;https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf
                Lato;https://www.latofonts.com/download/lato2ofl-zip/
                font-awesome;https://use.fontawesome.com/releases/v6.5.2/fontawesome-free-6.5.2-desktop.zip"
_shippedFontList="DankMono Liberata Bookerly"
_necessaryPkgs=("unzip:unzip" "fc-cache:fontconfig" "wget:wget")
### . END: SCRIPT_OPTIONS }


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


### BEGIN: FUNCTION_SECTION {
## BEGIN _xxxMsg {
_errMsg () { >&2 echo -e "${_redClr}ERROR:${_bldClr} $*${_norClr}"; }
_wrnMsg () { echo -e "${_yelClr}WARN:${_bldClr} $*${_norClr}";      }
_sucMsg () { echo -e "${_grnClr}SUCCESS:${_bldClr} $*${_norClr}";   }
_hedMsg () { echo -e "${_magClr}=!=${_bldClr} $*${_norClr}";        }
_endMsg () { echo -e "${_cyaClr}===${_bldClr} $*${_norClr}";        }
_infMsg () { echo -e "${_bldClr}*** $*${_norClr}";                  }
_skpMsg () { echo -e "${_graClr}***${_bldClr} $*${_norClr}";        }
_prgMsg () { echo -e "${_bluClr}|=>${_bldClr} $*${_norClr}";        }
## . END _xxxMsg }

## BEGIN _usageFn {
_usageFn () {
    cat << _EOH1
usage: $(basename "$0") [-h] [-d DDIR] [-t TDIR] [-a]
                        [-M] [-N] [-G] [-L] [-C FONT(s)]

  Install FONTS.

  -h          Show this help.
  -d DDIR     Specify installation directory.
  -t TDIR     Specify temporary unpacking directory.
  -a          Install all fonts.
  -M          Install only Microsoft fonts.
  -N          Install only Nerd Fonts.
  -G          Install only fonts from fonts.google.com
  -L          Install locally brought fonts.
  -C FONT(s)  Install custom fonts, comma separated list.
                (specify path to font directory)
_EOH1
}
## . END _usageFn }

## BEGIN _parseArgumentsFn {
_parseArgumentsFn () {
    while getopts ':hd:t:aMNGLC:' _option; do
        case "${_option}" in
            h)
                _usageFn
                exit
                ;;
            d) _chosen_install_dir="${OPTARG}"      ;;
            t) _chosen_tmp_dir="${OPTARG}"          ;;
            a) _install_all="set"                   ;;
            M) _install_microsoft_fonts="set"       ;;
            N) _install_nerd_fonts="set"            ;;
            G) _install_google_chosen_fonts="set"   ;;
            L) _install_local_fonts="set"           ;;
            C) _install_custom_fonts="${OPTARG}"    ;;
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

## BEGIN _checkBinariesFn {
_checkBinariesFn () {
    for _pkg in "${_necessaryPkgs[@]}"; do
        if ! command -v "${_pkg%:*}" &>/dev/null; then
            _errMsg "No command ${_pkg%:*} on the system. Please install package containing this binary, pkg like ${_pkg#*:}."
            exit 1
        fi
    done
}
## . END _checkBinariesFn }

## BEGIN _checkErrCodeAndPrintFn {
_checkErrCodeAndPrintFn () {
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
## . END _checkErrCodeAndPrintFn }

## BEGIN _downloadFontFn {
_downloadFontFn () {
    local _font_url _font_name _zip_file_location
    _font_url="${1:-}"
    _font_name="${2:-}"
    _zip_file_location="${3:-}"

    wget \
        --show-progress --quiet \
        -O "${_zip_file_location}/${_font_name}.zip" \
        "${_font_url}"
}
## . END _downloadFontFn }

## BEGIN _unpackFontFn {
_unpackFontFn () {
    local _tmp_location _font_name _font_destination
    _tmp_location="${1:-}"
    _font_name="${2:-}"
    _font_destination="${3:-}"

    [ ! -d "${_font_destination}/${_font_name}" ] \
        && mkdir -p "${_font_destination}/${_font_name}"

    unzip "${_tmp_location}/${_font_name}.zip" \
        -d "${_font_destination}/${_font_name}/"
}
## . END _unpackFontFn }

## BEGIN _installFontFn {
_installNerdFontFn () {
    local _font_name _font_url _tmp_location _font_destination
    _font_name="${1:-}"
    _font_url="${2:-}/${1:-}.zip"
    _tmp_location="${3:-}"
    _font_destination="${4:-}"

    _prgMsg "Installing font: ${_font_name}"
    _downloadFontFn "${_font_url}" "${_font_name}" "${_tmp_location}"
    _unpackFontFn "${_tmp_location}" "${_font_name}" "${_font_destination}"
}
## . END _installFontFn }

## BEGIN _installNerdFontFn {
_installOtherFontFn () {
    local _font_name _font_url _tmp_location _font_destination
    _font_name="${1%%;*}"
    _font_url="${1##*;}"
    _tmp_location="${2:-}"
    _font_destination="${3:-}"

    _prgMsg "Installing font: ${_font_name}"
    _downloadFontFn "${_font_url}" "${_font_name}" "${_tmp_location}"
    _unpackFontFn "${_tmp_location}" "${_font_name}" "${_font_destination}"
}
## . END _installNerdFontFn }

## BEGIN _installNerdFontFn {
_installShippedFontFn () {
    local _font_name _font_destination
    _font_name="${1:-}"
    _font_destination="${2:-}"

    _prgMsg "Installing font: ${_font_name}"
    cp -rv "$(dirname "$0")/${_font_name}" "${_font_destination}/"
}
## . END _installNerdFontFn }

## BEGIN _installMicrosoftFontsFn {
_installMicrosoftFontsFn () {
    local _font_destination _errcode
    _font_destination="${1:-}"

    _prgMsg "Installing: Microsoft Fonts"
    "$(dirname "$0")/install-microsoft-fonts.sh" "${_font_destination}"
    _errcode="$?"

    _checkErrCodeAndPrintFn "${_errcode}" \
        "Microsoft fonts installation has failed!" \
        "Microsoft fonts installation has succeeded!"

    return ${_errcode}
}
## . END _installMicrosoftFontsFn }

## BEGIN _installCustomFontsFn {
_installCustomFontsFn () {
    local _font_name _font_destination
    _font_name="${1:-}"
    _font_destination="${2:-}"

    _skpMsg "[ WIP ] Not yet implemented"
    true
}
## . END _installCustomFontsFn }

## BEGIN _updateCacheFn {
_updateCacheFn () {
    local _font_directory
    _font_directory="${1:-}"

    fc-cache -fv "${_font_directory}"
}
## . END _updateCacheFn }

## BEGIN _mainFn {
_mainFn () {
    local _temporary_files_location _local_font_location
    _parseArgumentsFn "$@"
    _checkBinariesFn

    _local_font_location="${_chosen_install_dir:-"${_localFontDirectory}"}"
    _temporary_files_location="${_chosen_tmp_dir:-"${_tempFontDirectory}"}"

    [ ! -d "${_temporary_files_location}" ] \
        && mkdir -p "${_temporary_files_location}"

    [ ! -d "${_local_font_location}" ] \
        && mkdir -p "${_local_font_location}"

    # install NerdFonts
    if [ "${_install_nerd_fonts}" ] || [ "${_install_all}" ]; then
        _hedMsg "Starting NerdFonts installation"
        _infMsg "Fonts to be installed: ${_nerdFontList}"
        for _font_name in ${_nerdFontList}; do
            _installNerdFontFn "${_font_name}" "${_nerdFontLink}" "${_temporary_files_location}" "${_local_font_location}"
        done
        _endMsg "End of NerdFonts installation"
    fi

    # install other Fonts
    if [ "${_install_google_chosen_fonts}" ] || [ "${_install_all}" ]; then
        _hedMsg "Starting other fonts installation"
        _infMsg "Fonts to be installed: $(for _i in ${_otherFontList}; do echo "${_i%%;*}"; done | xargs)"
        for _font_combo in ${_otherFontList}; do
            _installOtherFontFn "${_font_combo}" "${_temporary_files_location}" "${_local_font_location}"
        done
        _endMsg "End of other font installation"
    fi

    # install shipped with this script Fonts
    if [ "${_install_local_fonts}" ] || [ "${_install_all}" ]; then
        _hedMsg "Starting shipped fonts installation"
        _infMsg "Fonts to be installed: ${_shippedFontList}"
        for _font_name in ${_shippedFontList}; do
            _installShippedFontFn "${_font_name}" "${_local_font_location}"
        done
        _endMsg "End of shipped fonts installation"
    fi

    # install Microsoft Fonts
    if [ "${_install_microsoft_fonts}" ] || [ "${_install_all}" ]; then
        _hedMsg "Starting Microsoft fonts installation"
        _installMicrosoftFontsFn "${_local_font_location}"
        _endMsg "End of Microsoft fonts installation"
    fi

    if [ "${_install_custom_fonts}" ] || [ "${_install_all}" ]; then
        _hedMsg "Starting custom fonts installation"
        _chopped_custom_fonts="${_install_custom_fonts//,/ }"
        _infMsg "Fonts to be installed: ${_chopped_custom_fonts}"
        for _font_name in ${_chopped_custom_fonts}; do
            _installCustomFontsFn "${_font_name}" "${_local_font_location}"
        done
        _endMsg "End of shipped fonts installation"
    fi

    # update cache
    _infMsg "Update font cache"
    _updateCacheFn "${_local_font_location}"

    # cleanup
    _infMsg "Cleanup"
    rm -rf "${_temporary_files_location}"
}
## . END _mainFn }
### . END: FUNCTION_SECTION }


### BEGIN: MAIN_SECTION {
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
    _mainFn "$@"
fi
### . END: MAIN_SECTION }
