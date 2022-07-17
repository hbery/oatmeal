# -*- coding: utf-8 -*-
"""
description: Qtile keybindings file.
author: Adam Twardosz (github.com/hbery)
"""

# Qtile imports
from libqtile.config import Click, Drag, Key
from libqtile.lazy import lazy

# Local imports
from functions import Functions as clazy
from custom_keybindings import *
from groups import group_classes


class Keybindings:

    keys = []

    spawn_keys      = SPAWN_KEYS
    cmd_keys        = SPAWN_CMD_KEYS

    def create_qtile_keys(self):
        """Create keybindings for qtile operations."""
        qquit       = Key(QTILE_MODIFIER, QUIT, lazy.shutdown())
        qrestart    = Key(QTILE_MODIFIER, RESTART, lazy.restart())

        self.keys += [
                     qquit,
                     qrestart
                    ]

    def create_layout_keys(self):
        """Create keybindings for layout manipulation"""
        modifier = [CONTROL, MOD]

        flip_layout = Key(modifier, SWAP_FLIP, lazy.layout.flip())
        tgl_layout  = Key(modifier, TOOGLE_LAYOUT, lazy.next_layout())

        self.keys += [
                    tgl_layout,
                    flip_layout
                    ]

    def create_window_manipulation_keys(self):
        """Create keybindings for manipulating windows in layout."""
        wfocus_modifier = [CONTROL, MOD]    # window focus
        wsize_modifier  = [MOD]             # window size manipulation
        wman_modifier   = [MOD, SHIFT]      # window manipulation

        focus_left  = Key(wfocus_modifier, LEFT, lazy.layout.left())
        focus_right = Key(wfocus_modifier, RIGHT, lazy.layout.right())
        focus_down  = Key(wfocus_modifier, DOWN, lazy.layout.down())
        focus_up    = Key(wfocus_modifier, UP, lazy.layout.up())
        grow        = Key(wsize_modifier, GROW, lazy.layout.grow())
        shrink      = Key(wsize_modifier, SHRINK, lazy.layout.shrink())
        normalize   = Key(wsize_modifier, NORMALIZE, lazy.layout.normalize())
        maximize    = Key(wsize_modifier, MAXIMIZE, lazy.layout.maximize())

        swap_left   = Key(wman_modifier, LEFT, lazy.layout.swap_left())
        swap_right  = Key(wman_modifier, RIGHT, lazy.layout.swap_right())
        swap_down   = Key(wman_modifier, DOWN, lazy.layout.shuffle_down())
        swap_up     = Key(wman_modifier, UP, lazy.layout.shuffle_up())

        self.keys += [
                    focus_left,
                    focus_right,
                    focus_down,
                    focus_up
                    ]
        self.keys += [
                    grow,
                    shrink,
                    normalize,
                    maximize
                    ]
        self.keys += [
                    swap_left,
                    swap_right,
                    swap_down,
                    swap_up
                    ]

    def create_window_kill_keys(self):
        """Create keybindings for killing windows."""
        all_ex_curr = Key(TARGET_ALL_EXCEPT_CURRENT, KILL_KEY,
                          clazy.kill_all_windows_minus_current())
        all_        = Key(TARGET_ALL, KILL_KEY,
                          clazy.kill_all_windows())
        current     = Key(TARGET_CURRENT, KILL_KEY,
                          lazy.window.kill())

        self.keys += [all_ex_curr, all_, current]

    def create_floating_layout_keys(self):
        """Create keybindings for flaoting layout."""
        modifier    = [MOD, SHIFT]

        floating    = Key(modifier, TOOGLE_FLOATING,
                          lazy.window.toggle_floating())
        full        = Key(modifier, TOOGLE_FULL,
                          lazy.window.toggle_fullscreen())

        self.keys += [floating, full]

    def create_group_manipulation_keys(self):
        """Create keybindings for group manipulation."""
        group_modifier      = [MOD]
        group_swap_modifier = [CONTROL, SHIFT, MOD]
        screen_modifier     = [CONTROL, MOD]

        group_keys = []
        swap_to_group_keys = []
        for i, g in enumerate(group_classes):
            group_keys.append(
                      Key(group_modifier, str(i + 1),
                          lazy.group[g.name].toscreen())
                    )
            swap_to_group_keys.append(
                      Key(group_swap_modifier, str(i + 1),
                          lazy.window.togroup(g.name, switch_group=True))
                    )

        move_next   = Key(group_modifier, NEXT, lazy.screen.next_group())
        move_prev   = Key(group_modifier, PREV, lazy.screen.prev_group())

        swap_next   = Key(group_swap_modifier, NEXT,
                          clazy.window_to_next_group())
        swap_prev   = Key(group_swap_modifier, PREV,
                          clazy.window_to_prev_group())

        move_next_screen = Key(screen_modifier, NEXT, lazy.next_screen())
        move_prev_screen = Key(screen_modifier, PREV, lazy.next_screen())

        self.keys += group_keys
        self.keys += swap_to_group_keys
        self.keys += [
                    move_next,
                    move_prev,
                    swap_next,
                    swap_prev,
                    move_next_screen,
                    move_prev_screen
                    ]

    def create_appspawn_keys(self):
        """Create keybinding for spawning custom applications."""
        for spawn_key in self.spawn_keys:

            modifier, key, command = spawn_key

            keybinding = Key(modifier, key, lazy.spawn(command))

            self.keys.append(keybinding)

    def create_cmdexec_keys(self):
        """Create keybindings for executing command defined by user."""
        for cmd_key in self.cmd_keys:

            modifier, key, command = cmd_key

            keybinding = Key(modifier, key, lazy.spawncmd(command))

            self.keys.append(keybinding)

    def init_keys(self):
        """Initilize and return keybindings."""
        self.create_layout_keys()
        self.create_window_manipulation_keys()
        self.create_qtile_keys()
        self.create_window_kill_keys()
        self.create_floating_layout_keys()
        self.create_group_manipulation_keys()

        # Custom apps/scripts
        self.create_cmdexec_keys()
        self.create_appspawn_keys()

        return self.keys


class Mouse:
    def __init__(self, mod_key=MOD):
        self.mod = mod_key

    def init_mouse(self):
        """Initialize mouse keybindings."""
        mouse = [
            Drag([self.mod], "Button1", lazy.window.set_position_floating(),
                 start=lazy.window.get_position()),
            Drag([self.mod], "Button3", lazy.window.set_size_floating(),
                 start=lazy.window.get_size()),
            Click([self.mod], "Button2", lazy.window.bring_to_front())
        ]
        return mouse
