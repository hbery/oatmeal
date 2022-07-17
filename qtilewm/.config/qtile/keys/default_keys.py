# -*- coding: utf-8 -*-
"""
descritpion: Qtile default keybindings file.
author: Adam Twardosz (github.com/hbery)
"""

# Modifier Keys
MOD     = "mod4"
ALT     = "mod1"
ALTGR   = "mod5"
SHIFT   = "shift"
CONTROL = "control"

# Another modifiers
SUPER        = MOD

SWAP_KEY     = SHIFT
FLOATING_KEY = SHIFT

# Move between windows
LEFT   = "h"
RIGHT  = "l"
DOWN   = "j"
UP     = "k"

# Flip the layout
SWAP_FLIP  = "space"

# Change windows size
GROW       = "plus"
SHRINK     = "minus"
NORMALIZE  = "n"
MAXIMIZE   = "m"

# Floating layout
TOOGLE_FLOATING = "space"
TOOGLE_FULL     = "m"

# Groups key
# Move screen to next and previous group
NEXT = "Right"
PREV = "Left"

# Kill Functions
KILL_KEY                  = "c"

TARGET_CURRENT            = [MOD, SHIFT]
TARGET_ALL                = [CONTROL, MOD]
TARGET_ALL_EXCEPT_CURRENT = [MOD, ALTGR]

# Rotation key
TOOGLE_LAYOUT = "Tab"
