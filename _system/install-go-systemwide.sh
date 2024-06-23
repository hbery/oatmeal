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

_needCmdFn () {
    if ! command -v "${1:-}" &>/dev/null; then
        echo >&2 "Command ${1:-} does not exist on this system. Aborting.."
        exit 1
    fi
}

_getArchFn () {
    local _arch
    _arch="$(uname -m)"

    # I care only for amd64 and arm64
    # (once riscv64 is official for go - also riscv)
    case "${_arch}" in
        x86_64 | x86-64 | x64 | amd64) printf "amd64" ;;
        aarch64 | arm64)               printf "arm64" ;;
    esac
}

_makeGoPrerequisitiesFn () {
    for _pkg in "tail" "grep" "curl" "sed" "sort" "find" "uname"; do
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
    _goVersions="$(curl \
        --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --url "https://go.dev/doc/devel/release" \
        | sed -nr 's/.*<p id="(go.*)".*/\1/p' \
        | sort -ut'.' -k 2n -k 3n)"
    export _goVersions

    printf "%s.%s-%s.tar.gz" "$(_chooseGoVersionFn)" "linux" "$(_getArchFn)"
    unset _goVersions
}

_downloadGoTarballFn () {
    local _tarball
    _tarball="${1:-}"
    [[ -z "${_tarball}" ]] && _tarball="$(_craftGoPkgNameFn)"

    curl \
        --location --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --output "/tmp/${_tarball}" \
        --url "${_goDlLinkPrefix}/${_tarball}"
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

    local _pkg_name
    _pkg_name="$(_craftGoPkgNameFn)"
    echo "Installing golang version: ${_pkg_name/.tar.gz/}"

    _makeGoPrerequisitiesFn
    _downloadGoTarballFn "${_pkg_name}"
    _installTarballFn "${_pkg_name}"
    _linkGoBinariesFn
    _cleanupFn "${_pkg_name}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainGoFn "${@}"
fi
