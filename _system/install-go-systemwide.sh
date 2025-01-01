#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Install Golang system-wide
# ~~~

_goHome="${GO_HOME:-"/opt/go"}"
_goChosenVersion="${GO_VERSION:-"latest"}"
_goDlLinkPrefix="https://go.dev/dl"
_goDlReleaseFile="$(mktemp go-install.XXXXXX.json)"

_needCmdFn () {
    if ! command -v "${1:-}" &>/dev/null; then
        echo >&2 "Command ${1:-} does not exist on this system. Aborting.."
        exit 1
    fi
}

_getArchFn () {
    local _arch
    _arch="$(uname -m)"

    # I care only for amd64, arm64 and riscv64
    case "${_arch}" in
        x86_64 | x86-64 | x64 | amd64) printf "amd64"   ;;
        aarch64 | arm64)               printf "arm64"   ;;
        riscv64)                       printf "riscv64" ;;
    esac
}

_makeGoPrerequisitiesFn () {
    for _pkg in "tail" "grep" "curl" "find" "uname" "jq" "sha256sum"; do
        _needCmdFn "${_pkg}"
    done
}

_chooseGoVersionFn () {
    local _goVersion
    if [[ "${_goChosenVersion}" == "latest" ]]; then
        _goVersion="$(tail -1 <<<"${_goVersions}")"
    else
        _goVersion="$(grep -F "${_goChosenVersion}" <<<"${_goVersions}")"
    fi
    [[ -z "${_goVersion}" ]] && echo >&2 "No version chosen." && exit 1
    printf "%s" "${_goVersion}"
}

_craftGoPkgNameFn () {
    local _arch _kernel
    _arch="$(_getArchFn)"
    _kernel="$(uname -s)"; _kernel="${_kernel,,}"

    curl \
        --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --url "${_goDlLinkPrefix}/?mode=json&include=all" \
        > "${_goDlReleaseFile}"

    _goVersions="$(jq -r \
                       '[ .[] | select( .stable == true ) | .version ]
                        | sort_by( . | sub("^go"; "") | split(".") | map(tonumber) )
                        | .[]' \
                       "${_goDlReleaseFile}")"
    export _goVersions

    jq -r \
        --arg v "$(_chooseGoVersionFn)" \
        --arg a "${_arch}" \
        --arg k "${_kernel}" \
        '.[]
         | select( (.version == $v) )
         | .files[]
         | select( ( .kind == "archive" ) and ( .os == $k ) and ( .arch == $a ) )
         | .filename' \
        "${_goDlReleaseFile}"
    unset _goVersions
}

_downloadGoTarballFn () {
    local _tarballName
    _tarballName="${1:-}"
    [[ -z "${_tarballName}" ]] && _tarballName="$(_craftGoPkgNameFn)"

    _tarballSHASum="$(jq -r \
                          --arg f "${_tarballName}" \
                          '.[][]
                           | arrays
                           | .[]
                           | select(.filename == $f)
                           | .sha256' \
                          "${_goDlReleaseFile}")"
    [[ -z "${_tarballSHASum}" ]] && echo >&2 "Missing SHA sum for the downloaded tarball. Aborting.." && return 99

    curl \
        --location --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --output "/tmp/${_tarballName}" \
        --url "${_goDlLinkPrefix}/${_tarballName}"

    printf '%s  %s' "${_tarballSHASum}" "/tmp/${_tarballName}" | sha256sum -c -
}

_installTarballFn () {
    local _tarball
    _tarball="${1:-}"
    [[ -z "${_tarball}" ]] && _tarball="$(_craftGoPkgNameFn)"

    rm -rf "${_goHome}" \
        && tar -C "$(dirname "${_goHome}")" -xzf "/tmp/${_tarball}"
}

_linkGoBinariesFn () {
    while read -r _binary; do
        cat > "/usr/local/sbin/${_binary}" <<_EOH1
#!/bin/sh

exec "${_goHome}/bin/\${0##*/}" "\$@"
_EOH1
        chmod 0755 "/usr/local/sbin/${_binary}"
    done < <(find "${_goHome}/bin" -type f -exec basename -a -- {} +)
}

_cleanupFn () {
    rm -rf "${@}"
}

_mainGoFn () {
    if [[ $(id -u) -ne 0 ]]; then
        echo "Must run with sudo / as-root!"
        exit 1
    fi

    local _pkgName
    _pkgName="$(_craftGoPkgNameFn)"
    echo "Installing golang version: ${_pkgName/.tar.gz/}"

    _makeGoPrerequisitiesFn
    _downloadGoTarballFn "${_pkgName}" || exit
    _installTarballFn "${_pkgName}"    || exit
    _linkGoBinariesFn                  || exit
    _cleanupFn "${_pkgName}" "${_goDlReleaseFile:-}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainGoFn "${@:-}"
fi
