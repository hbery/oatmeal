# -*- coding: utf-8 -*-
"""
description: Qtile base configuration.
author: Adam Twardosz (github.com/hbery)
contains: (
    config.py,
---
    colors.py,
    custom_keybindings.py,
    functions.py,
    groups.py,
    icons/*,
    keys/default.py,
    keys/keybindings.py,
    screens.py, scripts/*,
    widgets.py,
)
"""

# System imports
import os
import subprocess

# Qtile imports
from libqtile import hook, layout
from libqtile.config import Match

# Local Imports
from keys.keybindings import Mouse, Keybindings
from layouts import HberyLayouts
from groups import HberyGroups
from screens import HberyScreen

""" MAIN """
if __name__ in ["config", "__main__"]:
    # INITIALIZES OBJECTS

    # INITIALIZES KEYBINDINGS
    obj_keys          = Keybindings()

    # MOUSE
    obj_mouse         = Mouse()
    obj_widgets       = HberyScreen(5)
    obj_layouts       = HberyLayouts()
    obj_groups        = HberyGroups()

    # INITIALIZES QTILE VARIABLES
    keys              = obj_keys.init_keys()
    mouse             = obj_mouse.init_mouse()
    layouts           = obj_layouts.init_layouts()
    groups            = obj_groups.init_groups()

    # DISPLAYS WIDGETS IN THE SCREEN
    screens           = obj_widgets.get_screens()


# ~~~   Qtile variables   ~~~ #
dgroups_key_binder = None

dgroups_app_rules = []  # type: list

follow_mouse_focus = False

bring_front_click = False

cursor_warp = False


floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='dialog'),  # Dialogs stuff
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(wm_class='oblogout'),  # logout script
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True

focus_on_window_activation = "smart"

reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
respect_minimize_requests = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
wmname = "LG3D"


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call(os.path.join(home, './.config/qtile/scripts/autostart.sh'))


@hook.subscribe.client_new
def dialogs(window):
    if(window.window.get_wm_type() == 'dialog'
       or window.window.get_wm_transient_for()):
        window.floating = True
