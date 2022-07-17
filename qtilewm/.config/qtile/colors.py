# -*- coding: utf-8 -*-
"""
description: Qtile colors file.
author: Adam Twardosz (github.com/hbery)
"""

# System imports
from collections import namedtuple


color_d = {
    "dark0": "#1d2021",
    "dark1": "#282828",
    "dark2": "#32302f",
    "dark3": "#3c3836",
    "dark4": "#504945",
    "dark5": "#665c54",
    "dark6": "#7c6f64",
    "gray0": "#928374",
    "light0": "#f9f5d7",
    "light1": "#fbf1c7",
    "light2": "#f2e5bc",
    "light3": "#ebdbb2",
    "light4": "#d5c4a1",
    "light5": "#bdae93",
    "light6": "#a89984",
    "red0": "#fb4934",
    "red1": "#cc241d",
    "red2": "#9d0006",
    "green0": "#b8bb26",
    "green1": "#98971a",
    "green2": "#79740e",
    "yellow0": "#fabd2f",
    "yellow1": "#d79921",
    "yellow2": "#b57614",
    "blue0": "#83a598",
    "blue1": "#458588",
    "blue2": "#076678",
    "purple0": "#d3869b",
    "purple1": "#b16286",
    "purple2": "#8f3f71",
    "aqua0": "#8ec07c",
    "aqua1": "#689d6a",
    "aqua2": "#427b58",
    "orange0": "#fe8019",
    "orange1": "#d65d0e",
    "orange2": "#af3a03",
    "deus1": '#2C323B',
    "deus2": '#646D7A',
    "deus3": '#48506D',
    "deus4": '#1A222F',
    "deus5": '#101A28',
}

ColorT = namedtuple("ColorT", color_d)
COLOR = ColorT(**color_d)
