#!/usr/bin/env bash
# ---
# Use "run program" to run it only if it is not already running
# Use "program &" to run it regardless
# ---
# NOTE: This script runs with every restart of Qtile


function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

run picom --experimental-backend &
run nitrogen --restore & 
run nm-applet &
run dunst &
# run xfce4-clipman
# run redshiftgui