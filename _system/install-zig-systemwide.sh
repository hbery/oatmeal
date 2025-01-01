#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Install Ziglang system-wide
# ~~~

_zigHome="${ZIG_HOME:-"/opt/zig"}"
_zigChosenVersion="${ZIG_VERSION:-"latest"}"
_zigDlReleaseLinkJson="https://ziglang.org/download/index.json"
_zigReleaseFile="$(mktemp 'zig-install.XXXXXX.json')"

_needCmdFn () {
    if ! command -v "${1:-}" &>/dev/null; then
        echo >&2 "Command ${1:-} does not exist on this system. Aborting.."
        return 1
    fi
}

_getArchFn () {
    local _arch
    _arch="$(uname -m)"

    # I care only for x86_64, aarch64 and riscv64
    case "${_arch}" in
        x86_64 | x86-64 | x64 | amd64) printf "x86_64"  ;;
        aarch64 | arm64)               printf "aarch64" ;;
        riscv64)                       printf "riscv64" ;;
    esac
}

_makeZigPrerequisitiesFn () {
    for _pkg in "tail" "grep" "curl" "jq" "find" "uname" "sha256sum"; do
        _needCmdFn "${_pkg}"
    done
}

_chooseZigVersionFn () {
    local _zigVersion
    if [[ "${_zigChosenVersion}" == "latest" ]]; then
        _zigVersion="$(tail -1 <<<"${_zigVersions}")"
    else
        _zigVersion="$(grep -F "${_zigChosenVersion}" <<<"${_zigVersions}")"
    fi
    [[ -z "${_zigVersion}" ]] && echo >&2 "No version chosen." && exit 1
    printf "%s" "${_zigVersion}"
}

_craftZigDlLinkFn () {
    curl \
        --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --url "${_zigDlReleaseLinkJson}" \
        > "${_zigReleaseFile}"
    _zigVersions="$(jq -r \
                        '[ keys[] | select( . == "master" | not ) ]
                         | sort_by(. | split(".") | map(tonumber))
                         | .[]' \
                        "${_zigReleaseFile}")"
    export _zigVersions

    jq -r \
        --arg v "$(_chooseZigVersionFn)" \
        --arg a "$(_getArchFn)-linux" \
        '.[$v][$a].tarball' \
        "${_zigReleaseFile}"
    export _zigSHASum _zigReleaseFile
    unset _zigVersions
}

_downloadZigTarballFn () {
    local _tarballLink _tarballName
    _tarballLink="${1:-}"
    _tarballName="${_tarballLink##*/}"
    [[ -z "${_tarballLink}" ]] && { _tarballLink="$(_craftZigDlLinkFn)"; _tarballName="${_tarballLink##*/}"; }

    _tarballSHASum="$(jq -r \
                          --arg t "${_tarballLink}" \
                          '.[][]
                           | objects
                           | select( .tarball == $t )
                           | .shasum' \
                          "${_zigReleaseFile}")"
    [[ -z "${_tarballSHASum}" ]] && echo >&2 "Missing SHA sum for the downloaded tarball. Aborting.." && return 99

    curl \
        --location --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --output "/tmp/${_tarballName}" \
        --url "${_tarballLink}"

    printf '%s  %s' "${_tarballSHASum}" "/tmp/${_tarballName}" | sha256sum -c -
}

_installZigTarballFn () {
    local _tarballName
    _tarballName="${1:-}"
    [[ -z "${_tarballName}" ]] && { _tarballName="$(_craftZigDlLinkFn)"; _tarballName="${_tarballName##*/}"; }

    rm -rf "${_zigHome}" \
        && tar -C "$(dirname "${_zigHome}")" -xJf "/tmp/${_tarballName}"

    mv -v "$(dirname "${_zigHome}")/${_tarballName/.tar.xz/}" "${_zigHome}"
    mkdir -p "${_zigHome}/bin"
    mv -v "${_zigHome}/zig" "${_zigHome}/bin/zig"
}

_linkZigBinariesFn () {
    while read -r _binary; do
        cat > "/usr/local/sbin/${_binary}" <<_EOH1
#!/bin/sh

exec "${_zigHome}/bin/\${0##*/}" "\$@"
_EOH1
        chmod 0755 "/usr/local/sbin/${_binary}"
    done < <(find "${_zigHome}/bin" -type f -exec basename -a -- {} +)
}

_cleanupFn () {
    rm -rf "${@}"
}

_mainZigFn () {
    if [[ $(id -u) -ne 0 ]]; then
        echo "Must run with sudo / as-root!"
        exit 1
    fi

    local _pkgName _pkgLink
    _pkgLink="$(_craftZigDlLinkFn)"
    _pkgName="${_pkgLink##*/}"
    echo "Installing zig version: ${_pkgName/.tar.xz/}"

    _makeZigPrerequisitiesFn            || exit
    _downloadZigTarballFn "${_pkgLink}" || exit
    _installZigTarballFn "${_pkgName}"  || exit
    _linkZigBinariesFn                  || exit
    _cleanupFn "${_pkgName}" "${_zigReleaseFile:-}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainZigFn "${@:-}"
fi
