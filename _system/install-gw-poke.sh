#!/bin/bash
#
# ~~~
# $date: 2024
# $author: Adam Twardosz (github.com/hbery)
# $description:
#   Install gw-poke
# ~~~

_scriptName="gw-poke"
_workingDirectory="$(realpath "$(dirname "$0")")"
_requiredFiles=("sh" "service" "timer")

_systemdUserPath="/etc/systemd/user"
_localSbinPath="/usr/local/sbin"

_fileExistsFn () {
    local _file; _file="${1:-}"
    if [[ ! -f "${_file}" ]]; then
        echo >&2 "File ${_file} not found."
        return 1
    fi
    return 0
}

_mainFn () {
    local _file
    for _t in "${_requiredFiles[@]}"; do
        _file="${_workingDirectory}/${_scriptName}.${_t}"

        _fileExistsFn "${_file}" || exit
        case "${_t}" in
            "sh")
                install --owner=root --group=root --mode=0755 "${_file}" "${_localSbinPath}"
                ;;
            "service"|"timer")
                install --owner=root --group=root --mode=0644 "${_file}" "${_systemdUserPath}"
                ;;
            *)
                echo >&2 "No such filetype considered."
                ;;
        esac
    done
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    _mainFn "${@:-}"
fi
