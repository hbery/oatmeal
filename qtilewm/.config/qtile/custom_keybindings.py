# -*- coding: utf-8 -*-
"""
description: Qtile custom application/script keybindings configuration file.
author: Adam Twardosz (github.com/hbery)
instructions:
Keybindings are configured with tuples, inside Predifined lists Variables

    Modifier: list  -> Ex: [MOD]
    Key: str        -> Ex: 'd'
    Command: str    -> Ex: vscode

    (Modifier, Key, Command)
"""

# System imports
from os.path import expanduser

# Local Imports
from keys.default_keys import *


# Define constants here
TERMINAL = "alacritty"
HOME = expanduser("~")

# Qtile shutdown/restart keys
QTILE_MODIFIER = [MOD, CONTROL]
RESTART        = "r"
QUIT           = "q"

""" ~~~   Hardware config keys   ~~~ """
HARDWARE_KEYS = [
    # Volume
    ([], "XF86AudioLowerVolume", "pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    ([], "XF86AudioRaiseVolume", "pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    ([], "XF86AudioMute", "pactl set-sink-mute @DEFAULT_SINK@ toggle"),

    # Brightness
    ([], "XF86MonBrightnessUp", f"{HOME}/.config/qtile/scripts/brightup"),
    ([], "XF86MonBrightnessDown", f"{HOME}/.config/qtile/scripts/brightdn"),
]

APPS = [
    ([MOD], "Return", TERMINAL),
    ([MOD], "e", "pcmanfm"),
    ([MOD], "d", "code"),
    ([MOD], "b", "brave"),
    ([MOD], "a", "pavucontrol"),
    ([MOD, CONTROL], "e", f"vim -g {HOME}/.config/qtile"),

    # Media hotkeys
    ([MOD], "Up", "pulseaudio-ctl up 5"),
    ([MOD], "Down", "pulseaudio-ctl down 5"),

    # Makes reference to play-pause script
    # You can find it in my scripts repository
    ([ALTGR], "space", "play-pause"),

    ([MOD], "space", 'rofi -modi "drun,run,window,ssh" -show drun'),

    # Screenshots
    ([], "Print", "xfce4-screenshooter"),
    # Full screen screenshot
    ([ALT], "Print", "xfce4-screenshooter -f -c"),

    # Terminal apps
    ([MOD, ALT], "v", TERMINAL + " -e vim"),

    # Logout script
    ([CONTROL, ALT], "Delete", "oblogout"),
]

SPAWN_KEYS = HARDWARE_KEYS + APPS

SPAWN_CMD_KEYS = [
    # Feel free to add something
]
