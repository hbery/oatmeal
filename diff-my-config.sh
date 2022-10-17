#!/bin/bash
# vim: ts=4 : sw=4 : et :
# ~~~
# Date: 2022
# Author: Adam Twardosz (github.com/hbery)
# Purpose: Compare changes between configs in home and this dotfiles dir.
#   Skip links as they are the same.
# ~~~

### BEGIN: SCRIPT_OPTIONS {
### . END: SCRIPT_OPTIONS }

### BEGIN: GLOBAL_SECTION {
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
    # TODO: create usage/help message
    cat << _EOH1
usage: $(basename "$0")

    TBD
_EOH1
}
## . END _usageFn }

## BEGIN _parseArgumentsFn {
 # parse commandline arguments for script to run
_parseArgumentsFn () {
    local _optionString=":h"
    while getopts "${_optionString}" _option
    do
        case "${_option}" in
            # TODO: parse arguments
            h)
                _usageFn
                exit
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
## BEGIN _mainFn {
_mainFn () {
    _parseArgumentsFn "$@"
    # TODO: do stuff
}
## . END _mainFn }
### . END: FUNCTION_SECTION }

### BEGIN: MAIN_SECTION {
if [ "${BASH_SOURCE[0]}" = "$0" ]
then
    _mainFn "$@"
fi
### . END: MAIN_SECTION }
