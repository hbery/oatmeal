#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# list monitors for Xorg

_num=$(xrandr --listmonitors | awk '{print $4}' | grep -c .)
 
if [[ ${_num} -gt 1 ]]; then
    _cmd=$(xrandr --listmonitors | awk '{print $4}' | xargs)

    _cnt=0
    for _disp in ${_cmd}; do
        if [ ${_cnt} -gt 0 ]; then
            echo "${_disp}"
        fi
        _cnt=$(( _cnt + 1 ))
    done
fi

