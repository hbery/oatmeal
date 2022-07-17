# -*- coding: utf-8 -*-
"""
description: Qtile helper functions file.
author: Adam Twardosz (github.com/hbery)
"""

# Qtile imports
from libqtile.command import lazy


class Functions:
    """ Move windows in groups functions. """
    @staticmethod
    def window_to_prev_group():
        @lazy.function
        def __inner(qtile):
            i = qtile.groups.index(qtile.current_group)

            if qtile.current_window and i != 0:
                group = qtile.groups[i - 1].name
                qtile.current_window.togroup(group, switch_group=True)

        return __inner

    @staticmethod
    def window_to_next_group():
        @lazy.function
        def __inner(qtile):
            i = qtile.groups.index(qtile.current_group)

            if qtile.current_window and i != len(qtile.groups):
                group = qtile.groups[i + 1].name
                qtile.current_window.togroup(group, switch_group=True)

        return __inner

    """ Killing windows functions. """
    @staticmethod
    def kill_all_windows():
        @lazy.function
        def __inner(qtile):
            for window in qtile.current_group.windows:
                window.kill()

        return __inner

    @staticmethod
    def kill_all_windows_minus_current():
        @lazy.function
        def __inner(qtile):
            for window in qtile.current_group.windows:
                if window != qtile.current_window:
                    window.kill()

        return __inner


if __name__ == "__main__":
    print("This is an utilities module")

