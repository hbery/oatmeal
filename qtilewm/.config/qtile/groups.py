# -*- coding: utf-8 -*-
"""
description: Qtile group configuration file.
author: Adam Twardosz (github.com/hbery)
"""

# System imports
from collections import namedtuple

# Qtile imports
from libqtile.config import Group


# Define groups
qGroup = namedtuple('qGroup', "name label layout")
group_classes = [
    qGroup(name="T", label=" \ue795 ", layout="monadtall"),
    qGroup(name="B", label=" \uf269 ", layout="max"),
    qGroup(name="D", label=" \uf121 ", layout="monadtall"),
    qGroup(name="M", label=" \uf885 ", layout="monadtall"),
    qGroup(name="C", label=" \uf075 ", layout="monadtall"),
    qGroup(name="V", label=" \uf16a ", layout="monadtall"),
    qGroup(name="E", label=" \uf74a ", layout="monadtall"),
    qGroup(name="X", label=" \uf7aa ", layout="monadtall"),
    qGroup(name="S", label=" \uf992 ", layout="floating")
]


class HberyGroups:
    groups = group_classes

    def init_groups(self):
        """Return the groups of Qtile."""
        mygroups = [Group(g.name, label=g.label, layout=g.layout)
                    for g in self.groups]

        return mygroups

