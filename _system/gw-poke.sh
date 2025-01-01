#!/bin/bash
# vim: ft=bash : ts=4 : sts=4 : sw=4 : et :
#
# Poke wireless gateway with arping when connection weakens to keep it alive.

_gw_address="$(ip route show default | cut -d' ' -f3)"

arping -c 2 -w 5 "${_gw_address}"
