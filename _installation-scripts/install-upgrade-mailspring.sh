#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# $date: 2025-06-
# $author: Adam Twardosz (github.com/hbery)
# $description: Install/Upgrade Mailspring mail client (github.com/foundry376/mailspring)

_redClr="\e[1;31m"
_grnClr="\e[1;32m"
_yelClr="\e[1;33m"
_bluClr="\e[1;34m"
_magClr="\e[1;35m"
_cyaClr="\e[1;36m"
_graClr="\e[2;37m"
_bldClr="\e[1m"
_norClr="\e[m"

_githubApi="https://api.github.com"
_githubHeaders=(
    "Accept: application/vnd.github+json"
    "X-GitHub-Api-Version: 2022-11-28"
)
_githubRepository="foundry376/mailspring"
_necessaryBins=(
    "curl"
    "wget"
    "jq"
    )
_pkgName="mailspring"

_errMsg () { >&2 echo -e "${_redClr}ERROR:${_norClr}${_bldClr} $*${_norClr}"; }
_infMsg () { echo -e "${_bldClr}*** $*${_norClr}";                            }

_checkNecessaryBinariesFn () {
    for _bin in "${@}"; do
        if ! command -v "${_bin%:*}" &>/dev/null; then
            _errMsg "No command ${_bin%:*} on the system. Please install package containing this binary, pkg containing binary/script \`${_bin#*:}\`."
            return 1
        fi
    done
}

_formatHeadersFn () {
    local _str
    _str=""
    for _h in "${_githubHeaders[@]}"; do
        _str="${_str} --header ${_h}"
    done
    printf "%s" "${_str}"
}

_getReleaseFromApiFn () {
    local _repository
    _repository="${1:-}"

    # shellcheck disable=SC2046
    curl -sL $(_formatHeadersFn) --url "${_githubApi}/repos/${_repository}/releases/latest"
}

_getReleaseNumberFn () {
    local _json
    _json="${1:-}"
    printf "%s" "${_json}" | jq --raw-output '.name'
}

_getAssetDownloadUrlFn () {
    local _search _json
    _search="${1:-}"
    _json="${2:-}"
    printf "%s" "${_json}" \
        | jq --raw-output --arg "search" "${_search}" \
            '.assets[] | select( .name | match($search) ) | .browser_download_url'
}

_getAssetChecksumFn () {
    local _search _json
    _search="${1:-}"
    _json="${2:-}"
    printf "%s" "${_json}" \
        | jq --raw-output --arg "search" "${_search}" \
            '.assets[] | select( .name | match($search) ) | .digest'
}

_distinguishOSFn () {
    sed -nr 's/^ID=(.*)/\1/p' /etc/os-release
}

_getCurrentVersionFn () {
    case "$(_distinguishOSFn)" in
        "ubuntu"|"debian")
            { dpkg-query --show "${_pkgName}" | cut -d$'\t' -f2; } 2>/dev/null || echo "-"
            return
            ;;
        "fedora")
            { rpm --query --json "${_pkgName}" | jq --raw-output '.Version'; } 2>/dev/null || echo "-"
            return
            ;;
        *)
            printf "%s" "error: os not supported" >&2
            return 1
            ;;
    esac
}

_selectSearchPatternFn () {
    case "$(_distinguishOSFn)" in
        "ubuntu"|"debian")
            printf "%s" ".*.deb$"
            return
            ;;
        "fedora")
            printf "%s" ".*.rpm$"
            return
            ;;
        *)
            printf "%s" "error: os not supported" >&2
            return 1
            ;;
    esac
}

_selectInstallCommandFn () {
    case "$(_distinguishOSFn)" in
        "ubuntu"|"debian")
            printf "%s" "apt install -yq"
            return
            ;;
        "fedora")
            printf "%s" "dnf install -yq"
            return
            ;;
        *)
            printf "%s" "error: os not supported" >&2
            return 1
            ;;
    esac
}

_downloadMailspringPkgFn () {
    local _url _file
    _url="${1:-}"
    _file="${2:-}"

    wget \
        --quiet \
        --show-progress \
        --progress=bar:force \
        --output-document="${_file}" \
        "${_url}"
}

_verifyMailspringPkgFn () {
    local _file _checksum
    _file="${1:-}"
    _checksum="${2:-}"
    echo "${_checksum/sha256:/} ${_file}" | sha256sum --check --quiet - 2>/dev/null
}

_installUpgradeMailspringPkgFn () {
    local _installCmd _packageFile
    _installCmd="${1:-}"
    _packageFile="${2:-}"

    if [[ "$(_distinguishOSFn)" == "fedora" ]]; then
        for d in $(rpm --query --package "${_packageFile}" --requires | grep -v lsb-core-noarch); do
            dnf install -yq $d
        done
        rpm -i --nodeps "${_packageFile}"
        return
    fi

    # shellcheck disable=SC2046
    ${_installCmd} "${_packageFile}"
}

_cleanupFn () {
    rm -rf "${@}"
}

_mainFn () {
    local _errno
    if [[ $(id -u) -ne 0 ]]; then
        echo >&2 "Must run as root/sudo!"
        exit 1
    fi

    _checkNecessaryBinariesFn "${_necessaryBins[@]}" || exit

    _installCmd="$(_selectInstallCommandFn)"
    _searchPattern="$(_selectSearchPatternFn)"

    _currentVersion="$(_getCurrentVersionFn)" || { _errno=$? && _errMsg _getCurrentVersionFn && exit ${_errno}; }

    _releaseOutput="$(_getReleaseFromApiFn "${_githubRepository}")" || { _errno=$? && _errMsg _getReleaseFromApiFn && exit ${_errno}; }
    _releaseVersion="$(_getReleaseNumberFn "${_releaseOutput}")" || { _errno=$? && _errMsg _getReleaseNumberFn && exit ${_errno}; }
    _releaseDLUrl="$(_getAssetDownloadUrlFn "${_searchPattern}" "${_releaseOutput}")" || { _errno=$? && _errMsg _getAssetDownloadUrlFn && exit ${_errno}; }
    _releaseChecksum="$(_getAssetChecksumFn "${_searchPattern}" "${_releaseOutput}")" || { _errno=$? && _errMsg _getAssetChecksumFn && exit ${_errno}; }

    if [[ "${_currentVersion}" == "${_releaseVersion}" ]]; then
        _infMsg "Mailspring is up to date!"
        exit
    fi

    cat << _EOH
*** MAILSPRING INSTALL/UPGRADE SCRIPT ***
~ hbery

Version present: ${_currentVersion}
Newest version: ${_releaseVersion}

Script will now install Mailspring:
    URL:    ${_releaseDLUrl}
    digest: ${_releaseChecksum}

***
_EOH

    _releaseFile="/tmp/${_releaseDLUrl##*/}"
    _downloadMailspringPkgFn "${_releaseDLUrl}" "${_releaseFile}" || { _errno=$? && _errMsg _downloadMailspringPkgFn && exit ${_errno}; }
    if [[ "${_releaseChecksum}" != "null" ]]; then
        _verifyMailspringPkgFn "${_releaseFile}" "${_releaseChecksum}"; _errno=$?
        if [[ ${_errno} -ne 0 ]]; then
            _errMsg "Package checksum mismatch. Aborting..."
            exit "${_errno}"
        fi
    fi

    _installUpgradeMailspringPkgFn "${_installCmd}" "${_releaseFile}" || { _errno=$? && _errMsg _installUpgradeMailspringPkgFn && exit ${_errno}; }
    _cleanupFn "${_releaseFile}"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    _mainFn "${@:-}"
fi
