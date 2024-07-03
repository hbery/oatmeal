#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# shellcheck disable=SC2015
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Install Hyprland Wayland Compositor alongside
#   with the dependencies and addons.
# ~~~
# MIT License
#
# Copyright (c) 2024 Adam Twardosz (github.com/hbery)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ~~~

set -euo pipefail
source /etc/os-release

# TODO: get better logging
_hyprinstallLogFile="/tmp/hyprinstall-$$.log"
exec &> >(tee -i "${_hyprinstallLogFile}")
_hyprinstallDir="${HOME}/git/hyprland-build"

_noDeps=
_noSddm=
_noHyprland=
_noAddons=
_noPlugins=
_noContrib=
_allLatest=
_noCleanup=
_reuseSourceDirs=
_buildVariablesExported=
declare -a _selectedAddons=()
declare -a _hyprlandPlugins=()
declare -a _contribScripts=()


_redClr="\e[1;31m"
_grnClr="\e[1;32m"
_yelClr="\e[1;33m"
_bluClr="\e[1;34m"
_magClr="\e[1;35m"
_cyaClr="\e[1;36m"
_graClr="\e[2;37m"
_bldClr="\e[1m"
_norClr="\e[m"

if [ "${ID}" = "ubuntu" ]; then
    _hyprlandVersion="${HYPRINSTALL_HYPRLAND_VERSION:-"0.41.1"}"

    _waylandProtocolsVersion="${HYPRINSTALL_WAYLAND_PROTOCOLS_VERSION:-"1.35"}"
    _waylandVersion="${HYPRINSTALL_WAYLAND_VERSION:-"1.23.0"}"
    _libdisplayInfoVersion="${HYPERINSTALL_LIBDISPLAY_INFO_VERSION:-"0.1.1"}"
    _libinputVersion="${HYPRINSTALL_LIBINPUT_VERSION:-"1.24.0"}"
    _libliftoffVersion="${HYPRINSTALL_LIBLIFTOFF_VERSION:-"0.4.1"}"
    _libxcbErrorsVersion="${HYPRINSTALL_LIBXCB_ERRORS_VERSION:-"xcb-util-errors-1.0.1"}"

    _hyprcursorVersion="${HYPRINSTALL_HYPRCURSOR_VERSION:-"0.1.9"}"
    _hyprlangVersion="${HYPRINSTALL_HYPRLANG_VERSION:-"0.5.2"}"
    _hyprwaylandScannerVersion="${HYPRINSTALL_HYPRWAYLAND_SCANNER_VERSION:-"0.3.10"}"
    _hyprutilsVersion="${HYPRINSTALL_HYPRUTILS_VERSION:-"0.1.4"}"

    _sddmVersion="${HYPRINSTALL_SDDM_VERSION:-"0.20.0"}"

    _gccVersion=
    _cmakeVersion=

    _ubuntuSpecificPackages=("vulkan-utility-libraries-dev")
elif [ "${ID}" = "debian" ]; then
    _hyprlandVersion="${HYPRINSTALL_HYPRLAND_VERSION:-"0.41.1"}"

    _waylandProtocolsVersion="${HYPRINSTALL_WAYLAND_PROTOCOLS_VERSION:-"1.35"}"
    _waylandVersion="${HYPRINSTALL_WAYLAND_VERSION:-"1.23.0"}"
    _libdisplayInfoVersion="${HYPERINSTALL_LIBDISPLAY_INFO_VERSION:-"0.1.1"}"
    _libinputVersion="${HYPRINSTALL_LIBINPUT_VERSION:-"1.24.0"}"
    _libliftoffVersion="${HYPRINSTALL_LIBLIFTOFF_VERSION:-"0.4.1"}"
    _libxcbErrorsVersion="${HYPRINSTALL_LIBXCB_ERRORS_VERSION:-"xcb-util-errors-1.0.1"}"

    _hyprcursorVersion="${HYPRINSTALL_HYPRCURSOR_VERSION:-"0.1.9"}"
    _hyprlangVersion="${HYPRINSTALL_HYPRLANG_VERSION:-"0.5.2"}"
    _hyprwaylandScannerVersion="${HYPRINSTALL_HYPRWAYLAND_SCANNER_VERSION:-"0.3.10"}"
    _hyprutilsVersion="${HYPRINSTALL_HYPRUTILS_VERSION:-"0.1.4"}"

    _sddmVersion="${HYPRINSTALL_SDDM_VERSION:-"0.20.0"}"

    # _gccVersion="${HYPRINSTALL_GCC_VERSION:-"13.3.0"}"
    _gccVersion="${HYPRINSTALL_GCC_VERSION:-"gcc-13"}"
    _cmakeVersion="${HYPRINSTALL_CMAKE_VERSION:-"3.29.6"}"

    _debianSpecificPackages=("vulkan-validationlayers-dev")
else
    exit 1
fi

_hyprpaperVersion="${HYPRINSTALL_HYPRPAPER_VERSION:-"0.7.0"}"
_hyprlockVersion="${HYPRINSTALL_HYPRLOCK_VERSION:-"0.3.0"}"
_hypridleVersion="${HYPRINSTALL_HYPRIDLE_VERSION:-"0.1.2"}"
_xdgDesktopPortalHyprlandVersion="${HYPRINSTALL_XDG_DESKTOP_PORTAL_HYPRLAND_VERSION:-"1.3.1"}"
_hyprlandPluginsVersion="${HYPRINSTALL_HYPRLAND_PLUGINS_VERSION:-"latest"}"
_hyprlandContribVersion="${HYPRINSTALL_HYPRLAND_CONTRIB_VERSION:-"0.1"}"

declare -A _repoSources=(
    ["wayland-protocols"]="freedesktop-gitlab wayland/wayland-protocols"
    ["wayland"]="freedesktop-gitlab wayland/wayland"
    ["libdisplay-info"]="freedesktop-gitlab emersion/libdisplay-info"
    ["libinput"]="freedesktop-gitlab libinput/libinput"
    ["libliftoff"]="freedesktop-gitlab emersion/libliftoff"
    ["libxcb-errors"]="freedesktop-gitlab xorg/lib/libxcb-errors"
    ["hyprcursor"]="github hyprwm/hyprcursor"
    ["hyprlang"]="github hyprwm/hyprlang"
    ["hyprwayland-scanner"]="github hyprwm/hyprwayland-scanner"
    ["hyprutils"]="github hyprwm/hyprutils"
    ["hyprpaper"]="github hyprwm/hyprpaper"
    ["hyprlock"]="github hyprwm/hyprlock"
    ["hypridle"]="github hyprwm/hypridle"
    ["xdg-desktop-portal-hyprland"]="github hyprwm/xdg-desktop-portal-hyprland"
    ["hyprland-plugins"]="github hyprwm/hyprland-plugins"
    ["hyprland-contrib"]="github hyprwm/contrib"
    ["sddm"]="github sddm/sddm"
    ["cmake"]="github Kitware/cmake"
)

_commonPackages=(
    wget
    build-essential
    meson
    ninja-build
    cmake
    cmake-extras
    automake
    check
    edid-decode
    extra-cmake-modules
    fontconfig
    gettext
    gettext-base
    glslang-tools
    hwdata
    libavcodec-dev
    libavformat-dev
    libavutil-dev
    libdrm-dev
    libegl1-mesa-dev
    libegl-dev
    libffi-dev
    libfontconfig-dev
    libgbm-dev
    libgles2
    libgtk-3-dev
    libgulkan-dev
    libinput-bin
    libinput-dev
    libpam0g-dev
    libpixman-1-dev
    libpugixml-dev
    librsvg2-dev
    libseat-dev
    libsystemd-dev
    libtomlplusplus-dev
    libtomlplusplus-dev
    libtool
    libudev-dev
    libvkfft-dev
    libvulkan-dev
    libvulkan-volk-dev
    libwlroots-dev
    libxcb-composite0-dev
    libxcb-dri3-dev
    libxcb-ewmh2
    libxcb-ewmh-dev
    libxcb-icccm4-dev
    libxcb-present-dev
    libxcb-render-util0-dev
    libxcb-res0-dev
    libxcb-util-dev
    libxcb-xinput-dev
    libxkbcommon-dev
    libxkbcommon-x11-dev
    libxkbregistry-dev
    libxml2-dev
    libzip-dev
    python3-docutils
    qt6-base-dev
    qt6-declarative-dev
    qt6-tools-dev
    qtbase5-dev
    qtdeclarative5-dev
    qttools5-dev
    seatd
    xcb-proto
    xdg-desktop-portal-wlr
    xutils-dev
    xwayland
)

_errMsg () { >&2 echo -e "${_redClr}ERROR:${_norClr}${_bldClr} $*${_norClr}"; }
_wrnMsg () { echo -e "${_yelClr}WARN:${_norClr}${_bldClr} $*${_norClr}";      }
_sucMsg () { echo -e "${_grnClr}SUCCESS:${_norClr}${_bldClr} $*${_norClr}";   }
_hedMsg () { echo -e "${_magClr}=!=${_norClr}${_bldClr} $*${_norClr}";        }
_endMsg () { echo -e "${_cyaClr}===${_norClr}${_bldClr} $*${_norClr}";        }
_infMsg () { echo -e "${_bldClr}*** $*${_norClr}";                            }
_skpMsg () { echo -e "${_graClr}***${_norClr}${_bldClr} $*${_norClr}";        }
_prgMsg () { echo -e "${_bluClr}|=>${_norClr}${_bldClr} $*${_norClr}";        }

_bannerMsg () {
    cat << _EOB
┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                =  =                                              │
│                                               ==  ==                                             │
│                                             -===  ====                                           │
│                                            ===*    ====                                          │
│                                           *==-      :===-                                        │
│                                         ====          ==*=                                       │
│                                        ====            ====                                      │
│                                       :==*              ====                                     │
│                                       ===                ===                                     │
│                                       =*=                =*=-                                    │
│                                       ==-                ===-                                    │
│                                       ===                ===                                     │
│                                        *==              ==*:                                     │
│                                         ===            ===                                       │
│                                           ====*    ======                                        │
│                                             :=======*-                                           │
│                                                                                                  │
│         dBP dBP dBP dBP dBBBBBb dBBBBBb    dBP dBBBBb.dBBBBP dBBBBBBP dBBBBBb     dBP    dBP     │
│                    dBP      dB'     dBP           dBPBP                    BB                    │
│       dBBBBBP     dBP   dBBBP'  dBBBBK   dBP dBP dBP 'BBBBb   dBP      dBP BB   dBP    dBP       │
│      dBP dBP     dBP   dBP     dBP  BB  dBP dBP dBP     dBP  dBP      dBP  BB  dBP    dBP        │
│     dBP dBP     dBP   dBP     dBP  dB' dBP dBP dBP dBBBBP'  dBP      dBBBBBBB dBBBBP dBBBBP      │
│                                                                                                  │
│                                            ~ by hbery ~                                          │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
_EOB
}

_usageFn () {
    cat << _EOH1
usage: $(basename "$0") [-help] [+nodeps] [+nosddm] [+nohypr] [+latest] [+noaddons] [+nocleanup] [+reusesrc]
                        [-addons ADDON1,ADDON2,..] [-plugins PLUG1,PLUG2,..] [-contrib SCRIPT1,SCRIPT2,..]

    Script to install Hyprland and few addons.
    Plugins and Contrib-scripts install is experimental (consider using hyprload).
    Script is destined to be used only on \`debian\` and \`ubuntu\`.

    -help               Show this help.
    +nodeps             Install just hyprland, no debian-needed dependencies.
    +nosddm             Install without custom sddm.
    +nohypr             Install without Hyprland.
                          (useful when installing just plugins and addons)
    +latest             Install all latest packages.
    +noaddons           Do not install addons, unless directly specified in \`-plugins\`.
    +nocleanup          Do not cleanup build directory.
    +noplugins          Do not install hyprland-plugins.
    +nocontrib          Do not install hyprland-contrib.
    +reusesrc           Reuse already downloaded/cloned source from libs/packages.
    -addons             Install custom addons, ',' separated.
                          (need to specify with +noaddons)
                        Available:
                          (hyprpaper,hyprlock,hypridle,xdg-desktop-portal-hyprland,hyprland-plugins,hyprland-contrib)
    -plugins            Specify plugins to install from hyprland-plugins, ',' separated.
                          (take dirnames from https://github.com/hyprwm/hyprland-plugins.git)
    -contrib            Specify contrib scripts from hyprland-contrib, ',' separated.
                          (take dirnames from https://github.com/hyprwm/contrib.git)

environment variables: (all prepended with 'HYPRINSTALL_' if you want change version)
    HYPRLAND_VERSION                    = ${_hyprlandVersion}
+ dependencies:
    WAYLAND_PROTOCOLS_VERSION           = ${_waylandProtocolsVersion}
    WAYLAND_VERSION                     = ${_waylandVersion}
    LIBDISPLAY_INFO_VERSION             = ${_libdisplayInfoVersion}
    LIBINPUT_VERSION                    = ${_libinputVersion}
    LIBLIFTOFF_VERSION                  = ${_libliftoffVersion}
    LIBXCB_ERRORS_VERSION               = ${_libxcbErrorsVersion}
    HYPRCURSOR_VERSION                  = ${_hyprcursorVersion}
    HYPRLANG_VERSION                    = ${_hyprlangVersion}
    HYPRWAYLAND_SCANNER_VERSION         = ${_hyprwaylandScannerVersion}
    HYPRUTILS_VERSION                   = ${_hyprutilsVersion}

+ addons:
    HYPRPAPER_VERSION                   = ${_hyprpaperVersion}
    HYPRLOCK_VERSION                    = ${_hyprlockVersion}
    HYPRIDLE_VERSION                    = ${_hypridleVersion}
    XDG_DESKTOP_PORTAL_HYPRLAND_VERSION = ${_xdgDesktopPortalHyprlandVersion}
    HYPRLAND_PLUGINS_VERSION            = ${_hyprlandPluginsVersion}
    HYPRLAND_CONTRIB_VERSION            = ${_hyprlandContribVersion}

+ debian-only:
    GCC_VERSION                         = ${_gccVersion}
    CMAKE_VERSION                       = ${_cmakeVersion}
_EOH1
}

_parseArgumentsFn () {
    while [[ $# -gt 0 ]]; do
        case "${1}" in
            -help)
                _usageFn
                exit
                ;;
            +nodeps)
                _noDeps="set"
                shift
                ;;
            +nosddm)
                _noSddm="set"
                shift
                ;;
            +nohypr)
                _noHyprland="set"
                shift
                ;;
            +latest)
                _allLatest="set"
                shift
                ;;
            +noaddons)
                _noAddons="set"
                shift
                ;;
            +noplugins)
                _noPlugins="set"
                shift
                ;;
            +nocontrib)
                _noContrib="set"
                shift
                ;;
            +nocleanup)
                _noCleanup="set"
                shift
                ;;
            +reusesrc)
                _reuseSourceDirs="set"
                shift
                ;;
            -addons)
                mapfile -t -d ',' _selectedAddons <<<"${2}"
                shift 2
                ;;
            -plugins)
                mapfile -t -d ',' _hyprlandPlugins <<<"${2}"
                shift 2
                ;;
            -contrib)
                mapfile -t -d ',' _contribScripts <<<"${2}"
                shift 2
                ;;
            -*|+*)
                echo >&2 "unknown option: ${1}"
                _usageFn >&2
                exit 1
                ;;
            *)
                if [[ "${1}" != "" ]]; then
                    echo >&2 "unknown positional argument: ${1}"
                    _usageFn >&2
                    exit 2
                fi
                shift
                ;;
        esac
    done

    if [[ -n "${_noAddons}" ]]; then
        _selectedAddons=()
    else
        if [[ ${#_hyprlandPlugins[@]} -gt 0 ]]; then
        case ":$(tr ' ' ':' <<<"${_selectedAddons[*]}"):" in
            *":hyprland-plugins:"*) ;;
            *)
                _wrnMsg "No 'hyprland-plugins' specified in \`-addons\`. Not installing selected plugins."
                _hyprlandPlugins=()
                ;;
        esac
        fi
        if [[ ${#_contribScripts[@]} -gt 0 ]]; then
        case ":$(tr ' ' ':' <<<"${_selectedAddons[*]}"):" in
            *":hyprland-contrib:"*) ;;
            *)
                _wrnMsg "No 'hyprland-contrib' specified in \`-addons\`. Not installing selected scripts."
                _contribScripts=()
                ;;
        esac
        fi
    fi

    if [[ -n "${_noPlugins}" && ${#_hyprlandPlugins[@]} -gt 0 ]]; then
        _wrnMsg "Specified \`+noplugins\`. Not installing 'hyprland-plugins'."; _hyprlandPlugins=()
    fi
    if [[ -n "${_noContrib}" && ${#_contribScripts[@]} -gt 0 ]]; then
        _wrnMsg "Specified \`+nocontrib\`. Not installing 'hyprland-contrib'."; _contribScripts=()
    fi
}

_deDupArrayFn () {
    # need to map again to array
    printf "%s\n" "${@}" | sort -u
}

_getVersionPartFn () {
    local _version _part
    _version="${1:-}"
    _part="${2:-}"

    case ":${_part}:" in
        ":major:"|":minor:")
            if [[ $(tr '.' ' ' <<<"${_version}" | wc -w) -eq 3 ]]; then
                perl -spe 's/(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)/$+{$vpart}/' -- -vpart="${_part}" <<<"${_version}"
            elif [[ $(tr '.' ' ' <<<"${_version}" | wc -w) -eq 2 ]]; then
                perl -spe 's/(?<major>\d+)\.(?<minor>\d+)/$+{$vpart}/' -- -vpart="${_part}" <<<"${_version}"
            fi
            ;;
        ":patch:")
            perl -spe 's/(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)/$+{$vpart}/' -- -vpart="${_part}" <<<"${_version}"
            ;;
        *) printf "%s" "${_version}" ;;
    esac
}

_getLatestOrValidateVersionFn () {
    local _repository _version _potential_version
    _repository="${1:-}"
    _version="${2:-}"

    if [[ -n "${_allLatest}" || "${_version}" == "latest" ]]; then
        _potential_version="$(git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' "${_repository}" \
            | awk 'END{print $2}' | tr -d '/[:alpha:]^}{')"

        if [ -z "${_potential_version}" ]; then
            _errMsg "Cannot find latest version tag in ${_repository}"
            exit 30
        fi
        printf "%s" "${_potential_version}"
    else
        if git -c 'versionsort.suffix=-' ls-remote --tags --sort='v:refname' "${_repository}" | grep "${_version}" &>/dev/null; then
            printf "%s" "${_version}"
        else
            _errMsg "No such version (${_version}) in ${_repository}"
            exit 31
        fi
    fi
}

_getSourceLinkFn () {
    local _origin _path
    _origin="${1:-}"
    _path="$(tr -d $'\n' <<<"$2")"

    case "${_origin}" in
        "github")             printf "https://github.com/%s.git" "${_path}"             ;;
        "freedesktop-gitlab") printf "https://gitlab.freedesktop.org/%s.git" "${_path}" ;;
        *) ;;
    esac
}

_getSourceTarballLinkFn () {
    local _origin _path _version
    _origin="${1:-}"
    _path="$(tr -d $'\n' <<<"$2")"
    _version="${3:-}"

    case "${_origin}" in
        "github")
            printf "https://github.com/%s/archive/refs/tags/v%s.tar.gz" \
                "${_path}" "${_version}"
            ;;
        "freedesktop-gitlab")
            printf "https://gitlab.freedesktop.org/%s/-/archive/%s/%s-%s.tar.gz" \
                "${_path}" "${_version}" "${_path##*/}" "${_version}"
            ;;
        *)  ;;
    esac
}

_installPackageDependenciesFn () {
    _infMsg "Installing Package Dependencies..."
    sudo apt-get install -y "${_commonPackages[@]}"
    case "${ID}" in
        "ubuntu") sudo apt-get install -yq "${_ubuntuSpecificPackages[@]}" ;;
        "debian") sudo apt-get install -yq "${_debianSpecificPackages[@]}" ;;
        *) ;;
    esac
}

_downloadSourceFn () {
    local _link _srcd_name _comp_algo _tar_opt
    _srcd_name="${1:-}"
    _link="${2:-}"
    _comp_algo="${_link##*.}"

    if [[ -n "${_reuseSourceDirs}" && -d "${_hyprinstallDir}/${_srcd_name}" ]]; then
        _infMsg "Tarball ${_srcd_name} already downloaded. Skipping downloading.."
        return
    fi

    _prgMsg "Downloading ${_srcd_name}..."
    _infMsg "  ..from ${_link}"

    wget --quiet --show-progress "${_link}" --output-document="/tmp/${_srcd_name}.tar.${_comp_algo}" || \
    {
        _errMsg "Failed to download source tarball ${_srcd_name}"
        exit 1
    }

    case "${_comp_algo}" in
        gz)     _tar_opt="--gzip" ;;
        xz)     _tar_opt="--xz" ;;
        bz2|bz) _tar_opt="--bzip2" ;;
        zip)
            unzip "/tmp/${_srcd_name}.tar.zip" -d "${_hyprinstallDir}/" || \
            {
                _errMsg "Failed to unzip /tmp/${_srcd_name}.tar.zip"
                exit 2
            }
            return
            ;;
    esac

    tar --extract "${_tar_opt}" --file="/tmp/${_srcd_name}.tar.${_comp_algo}" --directory="${_hyprinstallDir}" || \
    {
        _errMsg "Failed to untar /tmp/${_srcd_name}.tar.${_comp_algo}"
        exit 2
    }
}

_cloneSourceFn () {
    local _srcd_name _repository _release _recursive _checkout_later
    _srcd_name="${1:-}"
    _repository="${2:-}"
    _release="${3:-}"
    _recursive="${4:-}"
    _checkout_later=""

    if [[ -n "${_reuseSourceDirs}" && -d "${_hyprinstallDir}/${_srcd_name}" ]]; then
        _infMsg "Repository ${_srcd_name} already cloned. Skipping cloning.."
        return
    fi

    declare -a _git_args=("--quiet")
    if [ -n "${_recursive}" ]; then _git_args+=("--recursive"); fi
    if [[ ! "${_release}" =~ ^"tag="* ]]; then _git_args+=("--branch" "${_release}"); else _checkout_later="yes"; fi
    _git_args+=("${_repository}" "${_hyprinstallDir}/${_srcd_name}")

    set -x
    git clone "${_git_args[@]}"

    if [[ "${_checkout_later}" == "yes" ]]; then
        git -C "${_hyprinstallDir}/${_srcd_name}" checkout "${_release/tag=/}"
        if [[ "${_recursive}" == "yes" ]]; then
            git -C "${_hyprinstallDir}/${_srcd_name}" submodule update --recursive
        fi
    fi
    set +x
}

_setGccVariablesFn () {
    local _prefix _default_libs _new_libs _c_include_path _cplus_include_path _rpath
    _prefix="${1:-}"

    _prgMsg "Setting script-wide HYPRINSTALL_( CC CXX C_INCLUDE_PATH CPLUS_INCLUDE_PATH LD_LIBRARY_PATH RPATH ).."

    _infMsg "  ..Setting CC=${_prefix}/bin/gcc"
    HYPRINSTALL_CC="${_prefix}/bin/gcc"
    _infMsg "  ..Setting CXX=${_prefix}/bin/g++"
    HYPRINSTALL_CXX="${_prefix}/bin/g++"

    _default_libs="$(ld --verbose | grep SEARCH_DIR | tr -s ' ;' \\012 \
        | sed -nr 's/SEARCH_DIR\("=(.*)"\)/\1/p' | xargs | tr ' ' ':')"
    _new_libs="${_prefix}/lib64:${_prefix}/lib:${_prefix}/lib/gcc/$(uname -m)-pc-linux-gnu/$("${_prefix}/bin/gcc" -dumpversion)"

    _infMsg "  ..Setting LD_LIBRARY_PATH=${_new_libs}:..."
    HYPRINSTALL_LD_LIBRARY_PATH="${_new_libs}:${_default_libs}"

    _c_include_path="$(gcc -xc -E -v - </dev/null 2>&1 \
        | sed -nr '/^#include <.*> search starts here:/,/^End of search list\./{//!p}' | xargs | tr ' ' ':')"
    _cplus_include_path="$(gcc -xc++ -E -v - </dev/null 2>&1 \
        | sed -nr '/^#include <.*> search starts here:/,/^End of search list\./{//!p}' | xargs | tr ' ' ':')"

    _infMsg "  ..Setting C_INCLUDE_PATH=${_prefix}/lib/gcc/$(uname -m)-pc-linux-gnu/$("${_prefix}/bin/gcc" -dumpversion):..."
    HYPRINSTALL_C_INCLUDE_PATH="${_prefix}/lib/gcc/$(uname -m)-pc-linux-gnu/$("${_prefix}/bin/gcc" -dumpversion):${_c_include_path}"
    _infMsg "  ..Setting CPLUS_INCLUDE_PATH=${_prefix}/include/c++/$("${_prefix}/bin/g++" -dumpversion):..."
    HYPRINSTALL_CPLUS_INCLUDE_PATH="${_prefix}/include/c++/$("${_prefix}/bin/g++" -dumpversion):${_cplus_include_path}"

    _infMsg "  ..Setting RPATH=${_new_libs}"
    HYPRINSTALL_RPATH="${_new_libs}"
}

_exportGccVariablesFn () {
    if [[ -z "${_gccVersion}" ]]; then return; fi
    if [[ "${_buildVariablesExported}" == "yes" ]]; then
        _skpMsg "Variables: CC CXX LD_LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH RPATH already exported"
        return
    else
        _hedMsg "Exporting variables: CC CXX LD_LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH RPATH"
    fi
    OLD_CC="$CC"; CC="$HYPRINSTALL_CC"
    OLD_CXX="$CXX";                               CXX="$HYPRINSTALL_CXX"
    OLD_LD_LIBRARY_PATH="$LD_LIBRARY_PATH";       LD_LIBRARY_PATH="$HYPRINSTALL_LD_LIBRARY_PATH"
    OLD_C_INCLUDE_PATH="$C_INCLUDE_PATH";         C_INCLUDE_PATH="$HYPRINSTALL_C_INCLUDE_PATH"
    OLD_CPLUS_INCLUDE_PATH="$CPLUS_INCLUDE_PATH"; CPLUS_INCLUDE_PATH="$HYPRINSTALL_CPLUS_INCLUDE_PATH"
    OLD_RPATH="$RPATH";                           RPATH="$HYPRINSTALL_RPATH"
    export CC CXX LD_LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH RPATH
    _buildVariablesExported="yes"
}

_unsetGccVariablesFn () {
    if [[ -z "${_gccVersion}" ]]; then return; fi
    if [[ "${_buildVariablesExported}" == "no" ]]; then
        _skpMsg "Variables: CC CXX LD_LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH RPATH were not exported"
        return
    else
        _endMsg "Unsetting variables: CC CXX LD_LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH RPATH"
    fi
    if [ -n "$OLD_CC" ]; then CC="$OLD_CC"; else unset CC; fi
    if [ -n "$OLD_CXX" ]; then CXX="$OLD_CXX"; else unset CXX; fi
    if [ -n "$OLD_LD_LIBRARY_PATH" ]; then LD_LIBRARY_PATH="$OLD_LD_LIBRARY_PATH"; else unset LD_LIBRARY_PATH; fi
    if [ -n "$OLD_C_INCLUDE_PATH" ]; then C_INCLUDE_PATH="$OLD_C_INCLUDE_PATH"; else unset C_INCLUDE_PATH; fi
    if [ -n "$OLD_CPLUS_INCLUDE_PATH" ]; then CPLUS_INCLUDE_PATH="$OLD_CPLUS_INCLUDE_PATH"; else unset CPLUS_INCLUDE_PATH; fi
    if [ -n "$OLD_RPATH" ]; then RPATH="$OLD_RPATH"; else unset RPATH; fi
    _buildVariablesExported="no"
}

_dbiGccFn () {
    _hedMsg "Starting \`gcc\` install from source, version: ${_gccVersion}"
    local _source_repo
    # NOTE: Consider using below sources to match ubuntu's noble numbat release
    # _patch_name="$(curl -s https://patches.ubuntu.com/g/gcc-13/ | perl -ne 's/.*<a href="(gcc-13.*\.patch)">.*/$1/ and print')"
    # _patch_link="https://patches.ubuntu.com/g/gcc-13/${_patch_name}"
    # _source_tarball="https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.gz"
    _source_repo="https://gcc.gnu.org/git/gcc.git"

    _cloneSourceFn \
        "${_gccVersion}" \
        "${_source_repo}" \
        "releases/${_gccVersion}"

    pushd "${_hyprinstallDir}/${_gccVersion}" || exit 20

    if [[ ! -e "/opt/${_gccVersion%%.*}/bin/gcc" && ! -e "/opt/${_gccVersion%%.*}/bin/g++" ]]; then
        ./contrib/download_prerequisites
        mkdir build && pushd build
        ../configure \
            --prefix="/opt/${_gccVersion%%.*}" \
            --enable-languages=c,c++,fortran,go \
            --disable-multilib \
            && make bootstrap-lean \
                -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
        sudo make install || \
        {
            _errMsg "Failed to build/install \`gcc\`"
            exit 40
        }

        popd || exit 1
    fi

    popd || exit 1
    _endMsg "Finished \`gcc\` install from source"

    _setGccVariablesFn "/opt/${_gccVersion%%.*}" || \
    {
        _errMsg "Failed to export Gcc related variables"
        exit 70
    }
}

_dbiCmakeFn () {
    _hedMsg "Starting \`cmake\` install, version: ${_cmakeVersion}"
    local _repo_src=() _script_name
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["cmake"]}"

    _cmakeVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_cmakeVersion}")"

    _script_name="cmake-${_cmakeVersion}-$(uname -s | tr '[:upper:]' '[:lower:]')-$(uname -m).sh"
    if [[ ! -x "${_script_name}" ]]; then
        wget \
            --quiet \
            --show-progress \
            --output-document="${_hyprinstallDir}/cmake-${_cmakeVersion}.sh" \
            "$(_getSourceLinkFn "${_repo_src[@]}" | sed -nr 's/^(.*)\.git$/\1/p')/releases/download/v${_cmakeVersion}/${_script_name}"
        chmod 0755 "${_hyprinstallDir}/cmake-${_cmakeVersion}.sh"
    fi

    sudo mkdir -p "/opt/cmake-${_cmakeVersion}"
    sudo "${_hyprinstallDir}/cmake-${_cmakeVersion}.sh" \
        --skip-license \
        --exclude-subdir \
        --prefix="/opt/cmake-${_cmakeVersion}" || \
        {
            _errMsg "Failed to build/install \`cmake\`"
            exit 40
        }
    sudo chmod -R 0755 "/opt/cmake-${_cmakeVersion}/bin"

    _endMsg "Finished \`cmake\` install"

    _prgMsg "Adding script-wide new cmake to path.."
    _infMsg "  ..Adding /opt/cmake-${_cmakeVersion}/bin to PATH"
    export PATH="/opt/cmake-${_cmakeVersion}/bin:${PATH}"
}

_dbiHyprlandFn () {
    _hedMsg "Starting \`Hyprland\` install from source, version: ${_hyprlandVersion}"
    _hyprlandVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "github" "hyprwm/Hyprland")" \
        "${_hyprlandVersion}")"
    _cloneSourceFn \
        "hyprland-source" \
        "$(_getSourceLinkFn "github" "hyprwm/Hyprland")" \
        "tag=v${_hyprlandVersion}" \
        "yes"

    chmod a+rw "${_hyprinstallDir}/hyprland-source"
    pushd "${_hyprinstallDir}/hyprland-source" || exit 10

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:STRING=/usr \
        -B build \
        -G Ninja \
        && cmake \
            --build build \
            --config Release \
            --target all \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
        chmod -R 777 build && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`Hyprland\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`Hyprland\` install from source"
}

_dbiWaylandProtocolsFn () {
    _hedMsg "Starting \`wayland-protocols\` install from source, version: ${_waylandProtocolsVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["wayland-protocols"]}"

    _waylandProtocolsVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_waylandProtocolsVersion}")"
    _downloadSourceFn \
        "wayland-protocols-${_waylandProtocolsVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_waylandProtocolsVersion}")"

    pushd "${_hyprinstallDir}/wayland-protocols-${_waylandProtocolsVersion}" || exit 3

    meson setup \
        --prefix=/usr \
        --buildtype=release \
        build/ \
        && ninja \
            -C build/ \
            -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo ninja -C build/ install || \
    {
        _errMsg "Failed to build/install \`wayland-protocols\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`wayland-protocols\` install from source"
}

_dbiWaylandFn () {
    _hedMsg "Starting \`wayland\` install from source, version: ${_waylandVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["wayland"]}"

    _waylandVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_waylandVersion}")"
    _downloadSourceFn \
        "wayland-${_waylandVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_waylandVersion}")"

    pushd "${_hyprinstallDir}/wayland-${_waylandVersion}" || exit 2

    meson setup \
        --prefix=/usr \
        --buildtype=release \
        -Ddocumentation=false \
        build/ \
        && ninja \
            -C build/ \
            -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo ninja -C build/ install || \
    {
        _errMsg "Failed to build/install \`wayland\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`wayland\` install from source"
}

_dbiLibdisplayInfoFn () {
    _hedMsg "Starting \`libdisplay-info\` install from source, version: ${_libdisplayInfoVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["libdisplay-info"]}"

    _libdisplayInfoVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_libdisplayInfoVersion}")"
    _downloadSourceFn \
        "libdisplay-info-${_libdisplayInfoVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_libdisplayInfoVersion}")"

    pushd "${_hyprinstallDir}/libdisplay-info-${_libdisplayInfoVersion}" || exit 4

    meson setup \
        --prefix=/usr \
        --buildtype=release \
        build/ \
        && ninja \
            -C build/ \
            -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo ninja -C build/ install || \
    {
        _errMsg "Failed to build/install \`libdisplay-info\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`libdisplay-info\` install from source"
}

_dbiLibinputFn () {
    _hedMsg "Starting \`libinput\` install from source, version: ${_libinputVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["libinput"]}"

    _libinputVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_libinputVersion}")"
    _downloadSourceFn \
        "libinput-${_libinputVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_libinputVersion}")"

    pushd "${_hyprinstallDir}/libinput-${_libinputVersion}" || exit 5

    if [[ ! -f "/usr/include/xlocale.h" ]]; then
        sudo ln -s /usr/include/locale.h /usr/include/xlocale.h
    fi

    meson setup \
        --prefix=/usr \
        --buildtype=release \
        -Ddocumentation=false \
        build/ \
        && ninja \
            -C build/ \
            -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo ninja -C build/ install || \
    {
        _errMsg "Failed to build/install \`libinput\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`libinput\` install from source"
}

_dbiLibliftoffFn () {
    _hedMsg "Starting \`libliftoff\` install from source, version: ${_libliftoffVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["libliftoff"]}"

    _libliftoffVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_libliftoffVersion}")"
    _downloadSourceFn \
        "libliftoff-v${_libliftoffVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "v${_libliftoffVersion}")"

    pushd "${_hyprinstallDir}/libliftoff-v${_libliftoffVersion}" || exit 6

    meson setup \
        --prefix=/usr \
        --buildtype=release \
        build/ \
        && ninja \
            -C build/ \
            -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo ninja -C build/ install || \
    {
        _errMsg "Failed to build/install \`libliftoff\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`libliftoff\` install from source"
}

_dbiLibxcbErrorsFn () {
    _hedMsg "Starting \`libxcb-errors\` install from source, version: ${_libxcbErrorsVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["libxcb-errors"]}"

    if [ -d "${_hyprinstallDir}/libxcb-errors-${_libxcbErrorsVersion}" ]; then
        rm -rf "${_hyprinstallDir}/libxcb-errors-${_libxcbErrorsVersion}"
    fi
    _cloneSourceFn \
        "libxcb-errors-${_libxcbErrorsVersion}" \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_libxcbErrorsVersion}" \
        "yes"

    mkdir -p "${_hyprinstallDir}/libxcb-errors-${_libxcbErrorsVersion}/build"
    pushd "${_hyprinstallDir}/libxcb-errors-${_libxcbErrorsVersion}/build" || exit 5

    ../autogen.sh --prefix=/usr \
        && make \
            -j "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo make install || \
    {
        _errMsg "Failed to build/install \`libxcb-errors\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`libxcb-errors\` install from source"
}

_dbiHyprlangFn () {
    _hedMsg "Starting \`hyprlang\` install from source, version: ${_hyprlangVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprlang"]}"

    _hyprlangVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprlangVersion}")"
    _downloadSourceFn \
        "hyprlang-${_hyprlangVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprlangVersion}")"

    pushd "${_hyprinstallDir}/hyprlang-${_hyprlangVersion}" || exit 8

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -B build \
        && cmake \
            --build build \
            --config Release \
            --target hyprlang \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hyprlang\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`hyprlang\` install from source"
}

_dbiHyprcursorFn () {
    _hedMsg "Starting \`hyprcursor\` install from source, version: ${_hyprcursorVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprcursor"]}"

    _hyprcursor="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprcursorVersion}")"
    _downloadSourceFn \
        "hyprcursor-${_hyprcursorVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprcursorVersion}")"

    pushd "${_hyprinstallDir}/hyprcursor-${_hyprcursorVersion}" || exit 7

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    if [[ ! -f "/usr/include/toml++/toml.hpp" ]]; then
        sudo ln -sf /usr/include/toml++/toml.h /usr/include/toml++/toml.hpp
    fi

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -B build \
        && cmake \
            --build build \
            --config Release \
            --target all \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hyprcursor\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`hyprcursor\` install from source"
}

_dbiHyprwaylandScannerFn () {
    _hedMsg "Starting \`hyprwayland-scanner\` install from source, version: ${_hyprwaylandScannerVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprwayland-scanner"]}"

    _hyprwaylandScannerVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprwaylandScannerVersion}")"
    _downloadSourceFn \
        "hyprwayland-scanner-${_hyprwaylandScannerVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprwaylandScannerVersion}")"

    pushd "${_hyprinstallDir}/hyprwayland-scanner-${_hyprwaylandScannerVersion}" || exit 9

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -B build \
        && cmake \
            --build build \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hyprwayland-scanner\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`hyprwayland-scanner\` install from source"
}

_dbiHyprutilsFn () {
    _hedMsg "Starting \`hyprutils\` install from source, version: ${_hyprutilsVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprutils"]}"

    _hyprutilsVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprutilsVersion}")"
    _downloadSourceFn \
        "hyprlang-${_hyprutilsVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprutilsVersion}")"

    pushd "${_hyprinstallDir}/hyprutils-${_hyprutilsVersion}" || exit 8

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -B build \
        && cmake \
            --build build \
            --config Release \
            --target all \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hyprutils\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`hyprutils\` install from source"
}

_installDependenciesFn () {
    if [[ "$(gcc -dumpversion)" -lt 13 ]]; then
        _dbiGccFn
    fi
    if [[ -n "${_cmakeVersion}" ]]; then
        _dbiCmakeFn
    fi

    _dbiWaylandProtocolsFn
    _dbiWaylandFn
    _dbiLibdisplayInfoFn
    _dbiLibinputFn
    _dbiLibliftoffFn
    _dbiLibxcbErrorsFn

    if [[ $(_getVersionPartFn "${_hyprlandVersion}" "minor") -ge 40 ]]; then
        _dbiHyprlangFn
        _dbiHyprcursorFn
        _dbiHyprwaylandScannerFn
        _dbiHyprutilsFn
    fi
}

_dbiSddmFn () {
    _hedMsg "Starting \`sddm\` install from source, version: ${_sddmVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["sddm"]}"

    _sddmVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_sddmVersion}")"
    _downloadSourceFn \
        "sddm-${_sddmVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_sddmVersion}")"

    pushd "${_hyprinstallDir}/sddm-${_sddmVersion}/" || exit 10

    cmake \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DENABLE_JOURNALD:BOOL=ON \
        -DBUILD_MAN_PAGES:BOOL=ON \
        -DBUILD_WITH_QT6:BOOL=ON \
        -B build \
        && make \
            --directory=build \
            --jobs="$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo make --directory=build install || \
    {
        _errMsg "Failed to build/install \`sddm\`"
        exit 40
    }


    if [ -z "$(getent passwd sddm)" ]; then
        sudo useradd \
            --system \
            --create-home \
            --shell "/sbin/nologin" \
            --home-dir "/var/lib/sddm" \
            --comment "Simple Desktop Display Manager" \
            sddm
    fi

    popd || exit 1
    _endMsg "Finished \`sddm\` install from source"
}

_dbiHyprpaperFn () {
    _hedMsg "Starting \`hyprpaper\` install from source, version: ${_hyprpaperVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprpaper"]}"

    _hyprpaperVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprpaperVersion}")"
    _downloadSourceFn \
        "hyprpaper-${_hyprpaperVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprpaperVersion}")"

    pushd "${_hyprinstallDir}/hyprpaper-${_hyprpaperVersion}" || exit 11

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -B build \
        && cmake \
            --build build \
            --config Release \
            --target hyprpaper \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hyprpaper\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`hyprpaper\` install from source"
}

_dbiHyprlockFn () {
    _hedMsg "Starting \`hyprlock\` install from source, version: ${_hyprlockVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprlock"]}"

    _hyprlockVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprlockVersion}")"
    _downloadSourceFn \
        "hyprlock-${_hyprlockVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprlockVersion}")"

    pushd "${_hyprinstallDir}/hyprlock-${_hyprlockVersion}" || exit 12

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -B build \
        && cmake \
            --build build \
            --config Release \
            --target hyprlock \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hyprlock\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`hyprlock\` install from source"
}

_dbiHypridleFn () {
    _hedMsg "Starting \`hypridle\` install from source, version: ${_hypridleVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hypridle"]}"

    _hypridleVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hypridleVersion}")"
    _downloadSourceFn \
        "hypridle-${_hypridleVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hypridleVersion}")"

    pushd "${_hyprinstallDir}/hypridle-${_hypridleVersion}" || exit 13

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        --no-warn-unused-cli \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -B build \
        && cmake \
            --build build \
            --config Release \
            --target hypridle \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`hypridle\`"
        exit 40
    }

    popd || exit
    _endMsg "Finished \`hypridle\` install from source"
}

_dbiXdgDesktopPortalHyprlandFn () {
    _hedMsg "Starting \`xdg-desktop-portal-hyprland\` install from source, version: ${_xdgDesktopPortalHyprlandVersion}"
    local _repo_src=()
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["xdg-desktop-portal-hyprland"]}"

    _xdgDesktopPortalHyprlandVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_xdgDesktopPortalHyprlandVersion}")"
    _downloadSourceFn \
        "xdg-desktop-portal-hyprland-${_xdgDesktopPortalHyprlandVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_xdgDesktopPortalHyprlandVersion}")"

    pushd "${_hyprinstallDir}/xdg-desktop-portal-hyprland-${_xdgDesktopPortalHyprlandVersion}" || exit 14

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    cmake \
        -DCMAKE_INSTALL_LIBEXECDIR:PATH=/usr/lib \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -B build \
        && cmake \
            --build build \
            --parallel "$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)" && \
    sudo cmake --install build || \
    {
        _errMsg "Failed to build/install \`xdg-desktop-portal-hyprland\`"
        exit 40
    }

    popd || exit 1
    _endMsg "Finished \`xdg-desktop-portal-hyprland\` install from source"
}

# INFO: Consider removing plugins install and using https://github.com/Duckonaut/hyprload
_dbiHyprlandPluginsFn () {
    # NOTE: hyprwm/hyprland-plugins are not tagged/released
    _hedMsg "Starting \`hyprland-plugins\` install from source, version: ${_hyprlandPluginsVersion}"
    local _repo_src=()
    local _build_cmd
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprland-plugins"]}"

    _hyprlandPluginsVersion="$(_getLatestOrValidateVersionFn \
        "$(_getSourceLinkFn "${_repo_src[@]}")" \
        "${_hyprlandPluginsVersion}")"
    if [ -z "${_hyprlandPluginsVersion}" ]; then
        _hyprlandPluginsVersion="main"
        _cloneSourceFn \
            "hyprland-plugins-${_hyprlandPluginsVersion}" \
            "$(_getSourceLinkFn "${_repo_src[@]}")" \
            "${_hyprlandPluginsVersion}"
    else
        _downloadSourceFn \
            "hyprland-plugins-${_hyprlandPluginsVersion}" \
            "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprlandPluginsVersion}")"
    fi

    pushd "${_hyprinstallDir}/hyprland-plugins-${_hyprlandPluginsVersion}" || exit 13

    if [[ "${#_hyprlandPlugins}" -eq 0 ]]; then
        _skpMsg "No plugins specified. Skipping hyprland-plugins install."
        return
    fi

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    for _plugin in "${_hyprlandPlugins[@]}"; do
        _build_cmd="$(sed -nr '/^\['"${_plugin}"'\]$/,/^$/p' hyprpm.toml \
            | sed -nr '/^build = \[/,/^\]/p' | tr ',' ';' \
            | xargs | sed -nr 's/^build = \[ (.*) \]/\1/p')"
        if [[ -n "${_build_cmd}" ]]; then
            _prgMsg "Installing ${_plugin}"
            _infMsg "Running command: ${_build_cmd}"
            eval "${_build_cmd}" || \
            {
                _errMsg "Failed to build/install \`hyprland-plugin:${_plugin}\`"
                exit 40
            }

        else
            _wrnMsg "No such plugin like ${_plugin}. Continuing.."
        fi
        _build_cmd=""
    done

    popd || exit 1
    _endMsg "Finished \`hyprland-plugins\` install from source"
}

# INFO: Consider removing/extracting contrib and/or install them manually
_dbiHyprlandContribFn () {
    _hedMsg "Starting \`hyprland-contrib\` install from source, version: ${_hyprlandContribVersion}"
    local _repo_src=() _all_contrib_scripts=()
    local _cscripts_merged
    mapfile -t -d ' ' _repo_src <<<"${_repoSources["hyprland-contrib"]}"

    _hyprlandContribVersion="$(_getLatestOrValidateVersionFn "$(_getSourceLinkFn "${_repo_src[@]}")" "${_hyprlandContribVersion}")"
    _downloadSourceFn \
        "hyprlandContrib-${_hyprlandContribVersion}" \
        "$(_getSourceTarballLinkFn "${_repo_src[@]}" "${_hyprlandContribVersion}")"

    pushd "${_hyprinstallDir}/hyprlandContrib-${_hyprlandContribVersion}" || exit 13
    mapfile -t -d$'\n' _all_contrib_scripts \
        < <(find ./contrib -mindepth 1 -maxdepth 1 -type d ! -name ".*" -exec basename -a -- {} +)

    _exportGccVariablesFn
    trap "_unsetGccVariablesFn; trap - RETURN" RETURN

    _cscripts_merged="$(tr ' ' ':' <<<"${_all_contrib_scripts[*]}")"
    for _cscript in "${_contribScripts[@]}"; do
        case ":${_cscripts_merged}:" in
            *":${_cscript}:"*)
                make -C "${_cscript}" install || \
                {
                    _errMsg "Failed to build/install \`hyprland-contrib:${_cscript}\`"
                    exit 40
                } ;;
            *) _wrnMsg "No such contrib script as ${_cscript}. Continuing.." ;;
        esac
    done

    popd || exit 1
    _endMsg "Finished \`hyprland-contrib\` install from source"
}

_installAddonsFn () {
    local _selected_addons=()
    mapfile -t -d$'\n' _selected_addons < <(_deDupArrayFn "${_selectedAddons[@]}")
    [ "${#_selected_addons[@]}" -eq 0 ] && \
        _selected_addons=(
            "hyprpaper"
            "hyprlock"
            "hypridle"
            "xdg-desktop-portal-hyprland"
            "hyprland-plugins"
            "hyprland-contrib"
        )

    for _addon in "${_selected_addons[@]}"; do
        case "${_addon}" in
            "hyprpaper")                                        _dbiHyprpaperFn ;;
            "hyprlock")                                         _dbiHyprlockFn ;;
            "hypridle")                                         _dbiHypridleFn ;;
            "xdg-desktop-portal-hyprland")                      _dbiXdgDesktopPortalHyprlandFn ;;
            "hyprland-plugins") if [ -z "${_noPlugins}" ]; then _dbiHyprlandPluginsFn; fi ;;
            "hyprland-contrib") if [ -z "${_noContrib}" ]; then _dbiHyprlandContribFn; fi ;;
            *) _skpMsg "Skipping '${_addon}' as no install instructions found." ;;
        esac
    done
}

_cleanupFn () {
    set +x
    if [ -z "${_noCleanup}" ]; then
        cd "${_hyprinstallDir}/../"
        rm -rf "${_hyprinstallDir}"
    else
        # if +nocleanup, remove just `build` directories
        local _dirs=()
        mapfile -d -t$'\n' _dirs < <(find "${_hyprinstallDir}/" -mindepth 1 -maxdepth 1 -type d)

        for _d in "${_dirs[@]}"; do
            rm -rf "${_d}/build"
        done
    fi
}

_mainFn () {
    _parseArgumentsFn "${@:-}"
    _bannerMsg

    mkdir -p "${_hyprinstallDir}"
    trap _cleanupFn EXIT
    pushd "${_hyprinstallDir}" || exit 1

    _installPackageDependenciesFn
    if [ -z "${_noDeps}"     ]; then
        _installDependenciesFn
    else
        _exportGccVariablesFn "/opt/${_gccVersion%%.*}"
        export PATH="/opt/cmake-${_cmakeVersion}/bin:${PATH}"
    fi
    if [ -z "${_noSddm}"     ]; then _dbiSddmFn;             fi
    if [ -z "${_noHyprland}" ]; then _dbiHyprlandFn;         fi
    if [ -z "${_noAddons}"   ]; then _installAddonsFn;       fi

    popd || exit 1
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
