# -*- coding: utf-8 -*-
"""
description: Qtile screens configuration file
author: Adam Twardosz (github.com/hbery)
"""

# System imports
import screeninfo
from typing import List

# Qtile imports
from libqtile import bar
from libqtile.config import Screen

# Local Imports
from widgets import HberyWidgets


class HberyScreen:
    def __init__(self, systray_idx: int):
        self.systray_idxs = []
        self.systray_idxs.append(systray_idx)
        self.primary = 0

    def get_screens(self):
        """ Return Qtile screens to public. """
        monitors = self.detect_screens()
        return self.init_screens(monitors)

    def detect_screens(self) -> int:
        """ Detect how many screens are connected and active. """
        return screeninfo.get_monitors()

    def init_screens(self, monitors: list) -> list:
        """ Init Qtile screens. """
        scrns = []

        for mon in monitors:
            my_widgets = None
            if mon.is_primary:
                my_widgets = self.collect_widgets()
            else:
                my_widgets = self.collect_widgets(
                        except_widgets=self.systray_idxs)

            scrns.append(Screen(
                top=bar.Bar(
                    widgets=my_widgets,
                    opacity=1.0,
                    size=20
                ),
                x=mon.x,
                y=mon.y,
                width=mon.width,
                height=mon.height
            ))

        return scrns

    def collect_widgets(self, except_widgets: List[int] = None) -> list:
        """ Get Qtile widgets from HberyWidgets and return them as needed. """
        widClass = HberyWidgets()
        widgets = widClass.init_widgets_list()

        if except_widgets:
            lcnt = 0
            for w in sorted(except_widgets):
                widgets.pop(w - lcnt)
                lcnt += 1

        return widgets
