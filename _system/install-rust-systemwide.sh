#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# install RUST system-wide

_rustHome="${RUST_HOME:-"/opt/rust"}"
_rustProfile="${RUST_PROFILE:-"default"}"

_needCmdFn () {
    if ! command -v "${1:-}" &>/dev/null; then
        echo >&2 "Command ${1:-} does not exist on this system. Aborting.."
        exit 1
    fi
}

_makeRustPrerequisitiesFn () {
    mkdir -p "${_rustHome}" 2>/dev/null

    for _pkg in "curl" "find"; do
        _needCmdFn "${_pkg}"
    done
}

_downloadAndInstallRustFn () {
    curl \
        --silent --show-error --fail --proto '=https' --tlsv1.2 \
        --url "https://sh.rustup.rs" \
        |   CARGO_HOME="${_rustHome}" \
            RUSTUP_HOME="${_rustHome}" \
            sh -s -- \
                -y \
                --no-modify-path \
                --profile "${_rustProfile}"
}

_linkRustBinariesFn () {
    while read -r _binary; do
        cat > "/usr/local/sbin/${_binary}" <<_EOH1
#!/bin/sh

RUSTUP_HOME="${_rustHome}" exec "${_rustHome}/bin/\${0##*/}" "\$@"
_EOH1
        chmod 0755 "/usr/local/sbin/${_binary}"
    done < <(find "${_rustHome}/bin" -type f -exec basename -a -- {} +)
}

_mainRustFn () {
    if [[ $(id -u) -ne 0 ]]; then
        echo "Must run with sudo / as-root!"
        exit 1
    fi

    _makeRustPrerequisitiesFn
    _downloadAndInstallRustFn
    _linkRustBinariesFn
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainRustFn "${@}"
fi
