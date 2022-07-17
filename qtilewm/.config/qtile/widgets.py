# -*- coding: utf-8 -*-
"""
description: Widgets configuration file for Qtile
author: Adam Twardosz (github.com/hbery)
"""

# System imports
import os
from collections import namedtuple

# Qtile imports
from libqtile import widget

# Local Imports
from colors import COLOR


class HberyWidgets:
    def __init__(self):
        Clr = namedtuple(
                "Clr",
                [
                    "bar", "groupb", "focus", "unfocus", "black", "white",
                    "border", "wid1", "wid2", "wid3", "wid4", "wid5"
                ])

        self.clr = Clr(
            bar=COLOR.deus4,
            groupb=COLOR.red1,
            focus=COLOR.light0,
            unfocus=COLOR.deus3,
            border=COLOR.yellow2,
            black=COLOR.dark0,
            white=COLOR.light0,
            wid1=COLOR.yellow1,
            wid2=COLOR.orange0,
            wid3=COLOR.red1,
            wid4=COLOR.green1,
            wid5=COLOR.blue1
        )

    def init_widgets_list(self):
        ''' Function that returns the desired widgets in form of list. '''
        widgets_list = [
            widget.Sep(
                linewidth=0,
                padding=5,
                foreground=self.clr.bar,
                background=self.clr.bar
            ),
            widget.TextBox(
                font="Inconsolata for Powerline",
                text='\ue0bc',
                background=self.clr.groupb,
                foreground=self.clr.bar,
                padding=0,
                fontsize=45,
            ),
            widget.GroupBox(
                font="Ubuntu Bold",
                fontsize=25,
                margin_y=5,
                margin_x=0,
                padding_y=5,
                padding_x=3,
                borderwidth=0,
                active=self.clr.focus,
                inactive=self.clr.unfocus,
                rounded=True,
                highlight_method='block',
                urgent_alert_method='block',
                this_current_screen_border=self.clr.bar,
                this_screen_border=self.clr.groupb,
                other_current_screen_border=self.clr.bar,
                other_screen_border=self.clr.groupb,
                foreground=self.clr.border,
                background=self.clr.groupb,
                disable_drag=True
            ),
            widget.TextBox(
                font="Inconsolata for Powerline",
                text='\ue0bc',
                background=self.clr.bar,
                foreground=self.clr.groupb,
                padding=0,
                fontsize=45,
            ),
            widget.WindowName(
                font="Dank Mono",
                fmt='{:^90}',
                foreground=self.clr.focus,
                background=self.clr.bar,
                padding=0,
                fontsize=13
            ),
            widget.Systray(
                background=self.clr.bar,
                padding=5
            ),
            widget.TextBox(
                font="Ubuntu Mono Bold Nerd Font Complete",
                text='\ue0be',
                background=self.clr.bar,
                foreground=self.clr.wid1,
                padding=0,
                fontsize=45,
            ),
            widget.TextBox(
                text="\ufa7d",
                foreground=self.clr.black,
                background=self.clr.wid1,
                fontsize=25,
                padding=0,
                mouse_callbacks={
                    "Button1": lambda qtile:
                        qtile.cmd_spawn("alacritty -e pulsemixer")
                }
            ),
            widget.Volume(
                foreground=self.clr.black,
                background=self.clr.wid1,
                padding=5
            ),
            widget.TextBox(
                font="Inconsolata for Powerline",
                text='\ue0be',
                background=self.clr.wid1,
                foreground=self.clr.wid2,
                padding=0,
                fontsize=45
            ),
            widget.CurrentLayoutIcon(
                custom_icon_paths=[
                    os.path.expanduser(
                        "~/.config/qtile/icons/layouts"
                        )
                    ],
                foreground=self.clr.black,
                background=self.clr.wid2,
                padding=0,
                scale=0.8
            ),
            widget.TextBox(
                font="Inconsolata for Powerline",
                text='\ue0be',
                foreground=self.clr.wid3,
                background=self.clr.wid2,
                padding=0,
                fontsize=45
            ),
            widget.BatteryIcon(
                theme_path=os.path.expanduser(
                    '~/.config/qtile/icons/battery-icons'),
                foreground=self.clr.black,
                background=self.clr.wid3
            ),
            widget.TextBox(
                font="Inconsolata for Powerline",
                text='\ue0be',
                foreground=self.clr.wid4,
                background=self.clr.wid3,
                padding=0,
                fontsize=45
            ),
            widget.Clock(
                font="Source Code Pro Heavy",
                foreground=self.clr.black,
                background=self.clr.wid4,
                mouse_callbacks={
                    "Button1": lambda qtile: qtile.spawncmd('date')},
                format="\uf073 %a %d.%m.%Y  \uf017 %H:%M"
            ),
            widget.Sep(
                linewidth=0,
                padding=10,
                foreground=self.clr.black,
                background=self.clr.wid4
            ),
        ]

        return widgets_list
